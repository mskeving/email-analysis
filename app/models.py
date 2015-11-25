from app import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    markov_dict = db.Column(db.Text())
    markov_starter_words = db.Column(db.Text())
    addresses = db.relationship('EmailAddress')

    def address_str(self):
        '''
        change list of addresses into a string to use as
        query parameter'''
        email_addresses = [e.email_address for e in self.addresses]
        return "(%s)" % (" OR ").join(email_addresses)

    def all_pruned_text(self, user_id=None):
        '''
        returns a string of all the text one has written -
        from the pruned version'''
        if user_id is None:
            user_id = self.id

        msgs = Message.query.filter_by(sender=user_id).all()
        get_pruned = lambda x: x.pruned if x.pruned else ''
        pruned_text = map(get_pruned, msgs)
        return (' ').join(pruned_text)

    def count_number_of(self, str_to_match):
        if not str_to_match:
            return "no string provided"
        pruned_text = self.all_pruned_text()
        if not pruned_text:
            return "There was no text found for %s" % (self.name)
        return pruned_text.count(str_to_match)

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
    recipients = db.Column(db.Text())


class Markov(db.Model):
    __tablename__ = "markovs"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    chain = db.Column(db.Text())
    is_tweeted = db.Column(db.Boolean, default=False, nullable=False)

    def is_legit(self, chain):
        '''
        we want to know if the chain is actually just a sentence
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
