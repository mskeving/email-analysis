import app
import re
import base64
import json
import nltk.data

from apiclient import errors
from email.utils import parsedate_tz, mktime_tz
from nltk.tokenize import word_tokenize
from collections import defaultdict

from app.lib.gmail_api import GmailApi
from app.data.settings import family_list, prune_junk_from_message
from app.models import User, EmailAddress, Message

db = app.db
service = GmailApi().get_service()


def create_users():
    existing_users = [u.name for u in User.query.all()]
    for user in family_list:
        if user.name in existing_users:
            print ("Can't create user %s. Already exists") % user.name

        else:
            print ("Create: %s") % user.name
            new_user = User(name=user.name)
            db.session.add(new_user)
            db.session.commit()
            db.session.refresh(new_user)
            new_user_id = new_user.id

            for address in user.addresses:
                new_address = EmailAddress(
                        user_id=new_user_id,
                        email_address=address)
                db.session.add(new_address)
            db.session.commit()


def generate_query(sender=None,
                   recipient_addresses=None,
                   labels_to_exclude=''):
    """ recipient_addresses comes in as a list of email addresses.
    sender is a user instance. These queries correspond to what you
    would type in your gmail search field."""
    if not sender or not recipient_addresses:
        return "Cannot generate query without sender or recipients"

    recipients = "(%s)" % ((" AND ").join(recipient_addresses))
    return ("from:(%s) to: (%s) -label:%s" %
            (sender.address_str(), recipients, labels_to_exclude))


def add_messages():
    """ First, messages.list() for each family member to
    get all messages and their ids. Once we have all
    the ids, we can messages.get() to insert into db.

    We will only add new messages. This checks for existing
    message id's and skips them. """
    all_message_ids = []
    queries = []
    existing_message_ids = [m.message_id for m in Message.query.all()]
    users = User.query.all()
    address_objs = EmailAddress.query.all()
    email_address_to_user_ids = {}
    for obj in address_objs:
        email_address_to_user_ids[obj.email_address] = obj.user_id
    while len(users) > 0:
        # include all family members
        sender = users.pop() # keep family_list intact to get recipient list
        recipients = [user.address_str() for user in family_list if user.name != sender.name]
        queries.append(generate_query(sender, recipients, "chats"))

    # messages.list() section. This gets you the IDs. To get more detailed information
    # need to do messages.get() with that ID.
    print ("Running queries...")
    for query in queries:
        try:
            response = service.users().messages().list(userId='me', q=query).execute()

            messages = []
            if 'messages' in response:
                messages.extend(response['messages'])

            while 'nextPageToken' in response:
                page_token = response['nextPageToken']
                response = service.users().messages().list(userId='me',
                                                           q=query,
                                                           pageToken=page_token).execute()
                if 'messages' in response:
                    messages.extend(response['messages'])
            all_message_ids.extend([message['id'] for message in messages])

        except errors.HttpError as error:
            print ('An error occurred: %s') % error

    # messages.get() section
    message_infos = []
    commited_messages_count = 0
    print ("Getting messages...")
    for i, message_id in enumerate(all_message_ids):
        if message_id in existing_message_ids:
            print ("already have message %s") % message_id
            continue

        message_info = {'id': message_id,
                        'data': None,
                        'thread_id': None,
                        'subject': None,
                        'sender': None,
                        'recipients': None,
                        'body': None,
                        'pruned': None,
                        'send_time': None,
                        }
        try:
            response = service.users().messages().get(userId='me',
                                                      id=message_id,
                                                      format='full').execute()
            message_info['data'] = json.dumps(response)
            message_info['thread_id'] = response['threadId']
            for header in response['payload']['headers']:
                if header['name'] == "Subject":
                    subject = header['value'] if header['value'] else '(no subject)'
                    message_info['subject'] = subject
                if header['name'] == "From":
                    # comes in as "FirstName LastName <email@address.com>". Take whatever's in the
                    # brackets to get the email address.
                    regex = re.compile('<(.*?)>')
                    try:
                        email_address = regex.findall(header['value'])[0].lower()
                        message_info['sender'] = email_address_to_user_ids[email_address]
                    except Exception:
                        print ("Couldn't get sender from message id: %s, sender: %s") % (message_id, header['value'])
                        break
                if header['name'] == "To":
                    # Note: for now all emails include every family member, so recipients is a
                    # bit irrelevant. Will need to think through a better way to do this
                    # when you want to get more specific
                    message_info['recipients'] = header['value']
                if header['name'] == "Date":
                    message_info['send_time'] = header['value']
            if 'parts' in response['payload']:
                for part in response['payload']['parts']:
                    if part['mimeType'] == 'text/plain':
                        encoded_message = part['body']['data']
                        message_info['body'] = base64.urlsafe_b64decode(encoded_message.encode('utf-8'))
                        message_info['pruned'] = prune_junk_from_message(message_info['body']).decode('utf-8')
            message_infos.append(message_info)

            # commit in chunks so I don't have to start from scratch.
            chunk_size = 25
            if len(message_infos) == chunk_size or i >= len(all_message_ids) - chunk_size:
                # the second part of this if statements is so that if all_message_ids is not evenly
                # divisible by chunk_size, it will get the remainder. But, it means that it will do
                # chunk_size commits for the last chunk. (if there are 10 remaining, it will be 10
                # individual commits)
                for m in message_infos:
                    time = parsedate_tz(m['send_time'])
                    unix_timestamp = mktime_tz(time)

                    new_message = Message(
                        message_id=m['id'],
                        thread_id=m['thread_id'],
                        data=m['data'],
                        sender=m['sender'],
                        body=m['body'],
                        pruned=m['pruned'],
                        subject=m['subject'],
                        send_time=m['send_time'],
                        send_time_unix=unix_timestamp,
                        recipients=m['recipients'],
                    )
                    db.session.add(new_message)
                print ("committing %d messages. %d to go") % (chunk_size, len(all_message_ids) - i)
                db.session.commit()
                commited_messages_count += len(message_infos)
                # banking on the fact that all_message_ids % chunk_size != 0
                if message_infos < chunk_size:
                    print ("Finished adding %d new messages") % (commited_messages_count)
                message_infos = []

        except errors.HttpError as error:
            print ('An error occurred: %s') % error


def save_markov_info():
    """ This stores the markov_dict on user object as json.
    The dict has a 2 word prefex - {('a', 'b'): ['c', 'd', 'e']}
    you need to first jsonify the prefix, and then the whole dict,
    otherwise it complains about not having a string as the key.

    This also stores the starter words. These are words that begin
    sentences in the emails, so they are also candidates to start
    the markov chains.
    """
    users = User.query.all()
    for u in users:
        messages = Message.query.filter_by(sender=u.id).all()
        text = (' ').join([m.pruned for m in messages if m.pruned])

        print ("Creating markov dict for: %s") % u.name
        markov = defaultdict(list)
        words = word_tokenize(text)
        for i in xrange(len(words) - 2):
            current = words[i]
            next_word = words[i+1]
            prefix = (current, next_word)
            suffix = words[i + 2]
            if suffix not in markov[prefix]:
                markov[prefix].append(suffix)
        json_markov = json.dumps({json.dumps(k): v for k, v in markov.iteritems()})
        u.markov_dict = json_markov

        print ("Saving starter words for: %s") % (u.name)
        sent_detector = nltk.data.load('tokenizers/punkt/english.pickle')
        sentences = sent_detector.tokenize(text.strip())
        word_pairs = []
        for sentence in sentences:
            words = word_tokenize(sentence)
            if len(words) > 1:
                word_pairs.append((words[0], words[1]))
        u.markov_starter_words = json.dumps(word_pairs)

        db.session.add(u)
    db.session.commit()


def main():
    create_users()
    add_messages()
    save_markov_info()


if __name__ == '__main__':
    main()
