import app
import re
import base64
import json
import nltk.data

from sqlalchemy import asc
from apiclient import errors
from email.utils import parsedate_tz, mktime_tz
from nltk.tokenize import word_tokenize
from collections import defaultdict

from settings import settings
from app.lib.gmail_api import GmailApi
from app.models import User, EmailAddress, Message

# note: to run this locally but populate heroku's database,
# you need to create the app with heroku's database uri
db = app.db


def create_users():
    existing_users = [u.name for u in User.query.all()]
    for user in settings.user_list:
        if user.name in existing_users:
            # note: this means you won't be able to update a new user,
            # for example if they have a new email address.
            print ("Can't create user %s. Already exists") % user.name

        else:
            print ("Create: %s") % user.name
            new_user = User(name=user.name,
                            avatar_link=user.avatar_link)
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

    # Gmail Service authentication
    service = GmailApi().get_service()

    all_message_ids = []
    queries = []
    existing_message_ids = [m.message_id for m in Message.query.all()]
    users = User.query.all()
    address_objs = EmailAddress.query.all()
    email_address_to_email_ids = {}
    email_address_to_user_ids = {}
    for obj in address_objs:
        email_address_to_email_ids[obj.email_address] = obj.id
        email_address_to_user_ids[obj.email_address] = obj.user_id
    while len(users) > 0:
        # include all family members
        sender = users.pop()  # keep user_list intact to get recipient list
        recipients = [user.address_str() for user in settings.user_list if user.name != sender.name]
        queries.append(generate_query(sender, recipients, labels_to_exclude="chats"))

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
    new_message_ids = [x for x in all_message_ids if x not in existing_message_ids]

    print ("Getting messages...")
    for i, message_id in enumerate(new_message_ids):
        message_info = {'id': message_id,
                        'data': None,
                        'thread_id': None,
                        'subject': None,
                        'sender_user_id': None,
                        'sender_email_id': None,
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
                        message_info['sender_user_id'] = email_address_to_user_ids[email_address]
                        message_info['sender_email_id'] = email_address_to_email_ids[email_address]
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
                        prune_message = settings.email_handler.prune_junk_from_message
                        message_info['pruned'] = prune_message(message_info['body']).decode('utf-8')
            message_infos.append(message_info)

            # commit in chunks so I don't have to start from scratch.
            chunk_size = 25
            if len(message_infos) == chunk_size or i >= len(new_message_ids) - chunk_size:
                # the second part of this if statements is so that if all_message_ids is not evenly
                # divisible by chunk_size, it will get the remainder. But, it means that it will do
                # chunk_size commits for the last chunk. (if there are 10 remaining, it will be 10
                # individual commits)
                for m in message_infos:
                    if not m['send_time']:
                        print ("no send_time for message_id: %s") % m['id']
                        continue
                    time = parsedate_tz(m['send_time'])
                    unix_timestamp = mktime_tz(time)

                    new_message = Message(
                        message_id=m['id'],
                        thread_id=m['thread_id'],
                        data=m['data'],
                        sender_user_id=m['sender_user_id'],
                        sender_email_id=m['sender_email_id'],
                        body=m['body'],
                        pruned=m['pruned'],
                        subject=m['subject'],
                        send_time=m['send_time'],
                        send_time_unix=unix_timestamp,
                        recipients=m['recipients'],
                    )
                    db.session.add(new_message)
                print ("committing %d messages. %d to go") % (len(message_infos), len(all_message_ids) - i)
                db.session.commit()
                commited_messages_count += len(message_infos)
                # banking on the fact that all_message_ids % chunk_size != 0
                if message_infos < chunk_size:
                    print ("Finished adding %d new messages") % (commited_messages_count)
                message_infos = []

        except errors.HttpError as error:
            print ('An error occurred: %s') % error

    # get response times only after everything is committed
    calculate_response_times(new_message_ids)


def calculate_response_times(message_ids):
    ''' For each new message, find the thread, and recalculate
    all response times for messages in that thread. This is because
    we can't assume message_ids is coming in send_time order.
    '''
    for msg_id in message_ids:
        msg = Message.query.filter_by(message_id=msg_id).first()
        if msg:
            thread_id = msg.thread_id
            print "response time for thread: %r" % thread_id

            msgs = (Message.query.filter_by(thread_id=thread_id)
                    .order_by(asc(Message.send_time_unix)).all()
                    )
            curr = msgs[0]
            curr.response_time = None
            for m in msgs[1:]:
                prev = curr
                curr = m
                curr.response_time = (int(curr.send_time_unix) -
                                      int(prev.send_time_unix)
                                      )

    db.session.commit()


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
        text = (' ').join([m.pruned for m in u.messages if m.pruned])

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
