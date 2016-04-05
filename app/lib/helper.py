import re
import datetime
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


def convert_unix_to_readable(unix_timestamp):
    return datetime.datetime.fromtimestamp(
            int(unix_timestamp)
        ).strftime('%Y-%m-%d')


def capitalize(s):
    return s[0].upper() + s[1:].lower()

def seconds_to_time(s):
    total_secs = int(s)

    hours = total_secs / 60 / 60
    secs_left = total_secs - (hours * 60 * 60)

    mins = secs_left / 60
    seconds = secs_left - (mins * 60)


    h = 'hour' if hours == 1 else 'hours'
    m = 'min' if mins == 1 else 'mins'
    s = 'second' if seconds == 1 else 'seconds'

    return "%d %s and %d %s" % (hours, h, mins, m)
