from app import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    markov_dict = db.Column(db.Text())
    markov_starter_words = db.Column(db.Text())
    addresses = db.relationship('EmailAddress')

    def address_str(self):
        # change list of addresses into a string to use as
        # query parameter
        email_addresses = [e.email_address for e in self.addresses]
        return "(" + (" OR ").join(email_addresses) + ")"


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

    def to_api_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'chain': self.chain,
            'is_tweeted': self.is_tweeted,
        }
