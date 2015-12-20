import re
from email.utils import parsedate_tz, mktime_tz


def parse_recipients(msg):
    '''given a Message, return list of email addresses in 
    the to field. They come in the form "person_name <person@email.com>".
    We just want a list of addresses out of that between the <>.
    '''
    regex = re.compile('<(.*?)>')
    recipients = regex.findall(msg.recipients) if msg.recipients else []

    return recipients

def convert_timestamp_to_unix(timestamp):
    '''timestamp must be in the str form we get from gmail
    ex. u'Mon, 3 Aug 2015 16:42:49 -0400"
    '''
    t = parsedate_tz(timestamp)
    return mktime_tz(t)
