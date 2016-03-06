import re
from collections import Counter
import nltk

from app import app, db
from app.lib.helper import parse_recipients
from app.lib.functools import timeit

# nltk data is stored in root folder to play nice with heroku.
nltk.data.path.append('./nltk_data')


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    avatar_link = db.Column(db.Text())
    markov_dict = db.Column(db.Text())
    markov_starter_words = db.Column(db.Text())
    addresses = db.relationship('EmailAddress')
    messages = db.relationship('Message', backref='user')

    def __repr__(self):
        # This will be included in cache_key to make sure
        # keys are unique per person.
        return "%s(%s)" % (self.__class__.__name__, self.id)

    def address_str(self):
        '''change list of addresses into a string to use as
        query parameter'''
        email_addresses = [e.email_address for e in self.addresses]
        return "(%s)" % (" OR ").join(email_addresses)

    def all_pruned_text(self):
        '''returns a string of all the text one has written -
        from the pruned version'''
        get_pruned = lambda x: x.pruned if x.pruned else ''
        pruned_text = map(get_pruned, self.messages)
        return (' ').join(pruned_text)

    @app.cache.memoize(timeout=30)
    def get_word_list(self):
        text = self.all_pruned_text()
        words = nltk.tokenize.word_tokenize(text)
        self.word_list = words
        return words

    def count_number_of(self, str_to_match):
        '''pass in a string and this will count how many times it shows
        up in this user's emails (case sensitive and insensitive)
        '''
        pruned_text = self.all_pruned_text()
        if not pruned_text:
            return "There was no text found for %s" % (self.name)

        return {
            'case_sensitive': int(pruned_text.count(str_to_match)),
            'case_insensitive': int(pruned_text.lower().count(str_to_match.lower()))
        }

    def message_count(self):
        '''The number of unique messages this user has sent.'''
        return len(self.messages)

    def initiating_msgs(self):
        '''a message is considered initiating a thread if it
        doesn't start with "Re:"
        '''
        msgs = [m for m in self.messages if
                m.subject and m.subject[:3].lower() != 're:']
        return msgs

    def serialize_messages(self, msgs):
        return [m.to_api_dict() for m in msgs]

    @app.cache.memoize(timeout=30)
    def word_count(self):
        '''Take all_pruned_text and and let word_tokenize split it up
        into words. Get rid of punctuation.
        '''
        words = self.get_word_list()
        non_punct = re.compile('.*[A-Za-z0-9].*')  # must contain letter or digit
        filtered = [w for w in words if non_punct.match(w)]

        return len(filtered)

    def num_words_all_caps(self):
        words = self.get_word_list()
        return len([w for w in words if w.isupper()])

    def num_swear_words(self):
        f = open('app/lib/badwords.txt')
        bad_words = f.read().split('\r\n')

        users_words = self.get_word_list()
        users_bad_words = [w.lower() for w in users_words if w.lower() in bad_words]

        return Counter(users_bad_words)

    def avg_word_count_per_message(self):
        average = self.word_count() / self.message_count()
        return average

    def response_percentages(self):
        '''From here you should be able to tell favorites by seeing who this person
        has the highest response percentage for. This does not look at any cc info,
        just the first person in the 'to' field.

        this is how the percentages should look:
        person_1: {
            person_2: (100 * (responses to person_2 / total msgs person_2 has sent))
        }

        '''
        # Get a count of number of replies to unique email addresses.
        # We're only going to take the first email address that shows up
        # in message.recipients, because they're the 'true' recipient
        recipients = []
        for message in self.messages:
            msg_recipients = parse_recipients(message)
            if msg_recipients:
                recipients.append(msg_recipients[0])

        resp_counts = Counter(recipients)

        # we need to go through and aggregate based on people in our db. For example,
        # if person_1 has 3 email addresses, we want to combine all of those counts.
        all_users = self.query.all()
        resp_percentages = {}
        for user in all_users:
            if user.id == self.id: continue
            for email in [email.email_address for email in user.addresses]:
                if resp_counts.get(email, None):
                    resp_percentages[user.name] = resp_percentages.get(user.name, 0) + resp_counts[email]

            num_messages_received = user.message_count()
            num_resp = resp_percentages[user.name]
            resp_percentages[user.name] = 100 * float(num_resp) / float(num_messages_received)

        return resp_percentages

    def num_of_participated_threads(self):
        # participated_threads = number of unique thread ids from self.messages
        # participated_threads/Message.threads_count * 100
        pass

    def avg_response_time(self):
        counter = 0
        total = 0
        for msg in self.messages:
            if msg.response_time:
                counter += 1
                total += int(msg.response_time)
        return total/counter

    def to_api_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'addresses': [a.email_address for a in self.addresses],
            'avatar_link': self.avatar_link,
            'avg_word_count': self.avg_word_count_per_message(),
            'message_count': self.message_count(),
            'response_percentages': self.response_percentages(),
            'messages': self.serialize_messages(self.messages),
            'initiating_msgs': self.serialize_messages(self.initiating_msgs()),
            'num_words_all_caps': self.num_words_all_caps(),
            'word_count': self.word_count(),
            'avg_response_time': self.avg_response_time(),
        }


class EmailAddress(db.Model):
    __tablename__ = "addresses"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    email_address = db.Column(db.String(128), unique=True)
    messages = db.relationship('Message', backref='email_address')


class Message(db.Model):
    __tablename__ = "messages"

    id = db.Column(db.Integer, primary_key=True)
    message_id = db.Column(db.String(128), unique=True)
    thread_id = db.Column(db.String(128))
    data = db.Column(db.Text())
    body = db.Column(db.Text())
    subject = db.Column(db.Text())
    send_time = db.Column(db.String(64))
    send_time_unix = db.Column(db.String(64))
    pruned = db.Column(db.Text())
    # this only includes to: and not cc:
    recipients = db.Column(db.Text())
    response_time = db.Column(db.String(64))

    # keep id of both user and email_address so you can easily
    # do user.messages or email_address.messages
    sender_email_id = db.Column(db.Integer, db.ForeignKey('addresses.id'))
    sender_user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    @classmethod
    def longest_thread_subject_length(cls):
        ''' This returns the length and subject of the longest thread.
        In the future, we may want to just return a list of the top threads, given
        some limit and then we can do whatever we want with that info.
        '''
        thread_ids = [m.thread_id for m in cls.query.all()]
        longest_thread_id, thread_length = Counter(thread_ids).most_common(1)[0]
        subject = cls.query.filter_by(thread_id=longest_thread_id).first().subject

        # If there's a 'reply' part of the subject, we don't want it.
        subject = subject.split('RE: ')[-1]
        return subject, thread_length

    @classmethod
    def threads_count(cls):
        '''return the number of unique threads'''
        unique_threads = db.session.query(
                            cls.thread_id.distinct()
                            ).all()
        return len(unique_threads)

    @classmethod
    def timezone_counter(cls):
        all_messages = cls.query.all()
        timezones = []
        for m in all_messages:
            if m.send_time:
                timezones.append(m.send_time.split(' ')[-1])
        return Counter(timezones)

    @classmethod
    def outsiders(cls):
        '''find all other email addresses on threads that are not included
        in EmailAddress. We don't have cc info in here, so it's possible
        there are others we're missing here.'''
        all_messages = cls.query.all()
        our_emails = [e.email_address.lower() for e in EmailAddress.query.all()]
        outsider_emails = []

        for msg in all_messages:
            recipients = parse_recipients(msg)
            outsider_emails += [r.lower() for r in recipients if r.lower() not in our_emails]

        # depending on what's used to create a word cloud, this could become
        # (' ').join(outsider_emails) so it's just a string of recipients
        return Counter(outsider_emails)

    def to_api_dict(self):
        return {
            'id': self.id,
            'send_time_unix': self.send_time_unix,
        }


class Markov(db.Model):
    __tablename__ = "markovs"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    chain = db.Column(db.Text())
    is_tweeted = db.Column(db.Boolean, default=False, nullable=False)

    def is_legit(self, chain):
        '''we want to know if the chain is actually a sentence
        someone typed. If it is, we're not considering it a legit
        markov chain. at least not for our tweeting purposes.'''
        user = User.query.filter_by(id=self.user_id).first()
        pruned_text = user.all_pruned_text()
        return chain not in pruned_text

    def to_api_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'chain': self.chain,
            'is_tweeted': self.is_tweeted,
            'is_legit': self.is_legit(self.chain),
        }


class DatabaseImport(db.Model):
    __tablename__ = "db_imports"
    id = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.String(64))
