import re
from collections import Counter

from app import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    markov_dict = db.Column(db.Text())
    markov_starter_words = db.Column(db.Text())
    addresses = db.relationship('EmailAddress')

    def address_str(self):
        '''change list of addresses into a string to use as
        query parameter'''
        email_addresses = [e.email_address for e in self.addresses]
        return "(%s)" % (" OR ").join(email_addresses)

    def all_pruned_text(self, user_id=None):
        '''returns a string of all the text one has written -
        from the pruned version'''
        if user_id is None:
            user_id = self.id

        msgs = Message.query.filter_by(sender=user_id).all()
        get_pruned = lambda x: x.pruned if x.pruned else ''
        pruned_text = map(get_pruned, msgs)
        return (' ').join(pruned_text)

    def count_number_of(self, str_to_match):
        '''pass in a string and this will count how many times it shows
        up in this user's emails (case sensitive and insensitive)
        '''
        pruned_text = self.all_pruned_text()
        if not pruned_text:
            return "There was no text found for %s" % (self.name)

        return {
            'case_sensitive': pruned_text.count(str_to_match),
            'case_insensitive': pruned_text.lower().count(str_to_match.lower())
        }

    def message_count(self):
        return Message.query.filter_by(sender=self.id).count()

    def word_count(self):
        '''This just takes all_pruned_text and splits it on the spaces.
        I'm sure the nltk library has more accurate word count...
        '''
        text = self.all_pruned_text()
        words = text.split(' ')
        return len(words)

    def avg_word_count_per_message(self):
        return self.word_count / self.message_count

    def response_percentages(self):
        '''From here you should be able to tell favorites by seeing who this person
        has the highest response percentage for. This does not look at any cc info,
        just the first person in the 'to' field.

        this is how the percentages should look:
        person_1: {
            person_2: (100 * (responses to person_2 / total msgs person_2 has sent))
        }

        '''
        # recipients come in the form "person_name <person@email.com>".
        # we just want a list of addresses out of that between the <>.
        regex = re.compile('<(.*?)>')

        # Get a count of number of replies to unique email addresses.
        # We're only going to take the first email address that shows up
        # in message.recipients, because they're the 'true' recipient
        messages_sent = Message.query.filter_by(sender=self.id).all()
        recipients = []
        for message in messages_sent:
            try:
                recipients.append(regex.findall(message.recipients)[0])
            except:
                continue

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


class EmailAddress(db.Model):
    __tablename__ = "addresses"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    email_address = db.Column(db.String(128), unique=True)


class Message(db.Model):
    __tablename__ = "messages"

    id = db.Column(db.Integer, primary_key=True)
    message_id = db.Column(db.String(128), unique=True)
    thread_id = db.Column(db.String(128))
    data = db.Column(db.Text())
    sender = db.Column(db.Integer, db.ForeignKey('addresses.id'))
    body = db.Column(db.Text())
    subject = db.Column(db.Text())
    send_time = db.Column(db.String(64))
    pruned = db.Column(db.Text())
    recipients = db.Column(db.Text()) # this only includes to: and not cc:

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
        pruned_text = user.all_pruned_text(self.user_id)
        return chain not in pruned_text

    def to_api_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'chain': self.chain,
            'is_tweeted': self.is_tweeted,
            'is_legit': self.is_legit(self.chain),
        }
