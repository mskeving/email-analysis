from apiclient import errors
from config import black_listed_subjects, prune_junk_from_message
from gmail_api import GmailApi

service = GmailApi().get_service()


def get_all_family_messages(user_list):
    family_messages = []
    for user in user_list:
        family_messages.extend(get_all_messages_from(user))

    return family_messages


def get_all_family_threads(user_list):
    family_threads = []
    for user in user_list:
        family_threads.extend(get_threads_from(user))
    return family_threads


def get_all_messages_from(user):
    query = user.query_all_messages_from()
    print query

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
            messages.extend(response['messages'])

        return messages

    except errors.HttpError, error:
        print 'An error occurred: %s' % error


def save_messages_from(user):
    import base64
    # threads().get() messages are base64. messages().get() are base64url

    # parts to save: subject, sender, to, cc, time, message_id, thread_id, body
    # attachments? images inline? links? emoticons?
    messages = get_all_messages_from(user)
    canonical = open(user.canonical_file, 'w')
    pruned = open(user.pruned_file, 'w')

    for message in messages:
        skip_this_message = False
        response = service.users().messages().get(userId='me',
                                                  id=message['id'],
                                                  format='full').execute()
        for header in response['payload']['headers']:
            if header['name'] == "Subject":
                for subject in black_listed_subjects:
                    if subject in header['value']:
                        skip_this_message = True
                print header['value'] if header['value'] else '(no subject)'
                break
        if 'parts' in response['payload'] and not skip_this_message:
            for part in response['payload']['parts']:
                if part['mimeType'] == 'text/plain':
                    encoded_message = part['body']['data']
                    decoded_message = base64.urlsafe_b64decode(str(encoded_message))
                    canonical.write(decoded_message)
                    pruned.write(prune_junk_from_message(decoded_message))
                    break
    canonical.close()
    pruned.close()
    return


def get_threads_from(user):
    query = user.query_all_messages_from()

    try:
        response = service.users().threads().list(userId='me', q=query).execute()
        threads = []
        if 'threads' in response:
            threads.extend(response['threads'])
        while 'nextPageToken' in response:
            page_token = response['nextPageToken']
            response = service.users().threads().list(userId='me', q=query,
                                            pageToken=page_token).execute()
            threads.extend(response['threads'])

    except errors.HttpError, error:
        print 'An error occurred: %s' % error

    return threads


def thread_initiation_count(user):
    return len(get_threads_from(user))


def response_count(user):
    return len(get_all_messages_from(user))


def print_subjects(threads):
    for thread in threads:
        try:
            thread_info = service.users().threads().get(userId='me', id=thread['id']).execute()
            original_msg = thread_info['messages'][0]
            for header in original_msg['payload']['headers']:
                if header['name'] == "Subject":
                    print header['value'] if header['value'] else '(no subject)'

        except errors.HttpError, error:
            print 'An error occurred: %s' % error
