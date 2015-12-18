import re


def parse_recipients(msg):
    '''given a Message, return list of email addresses in 
    the to field. They come in the form "person_name <person@email.com>".
    We just want a list of addresses out of that between the <>.
    '''
    regex = re.compile('<(.*?)>')
    recipients = regex.findall(msg.recipients) if msg.recipients else []

    return recipients
