from app import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    addresses = db.relationship('EmailAddress', backref='user')
    pruned_text = db.Column(db.UnicodeText())
    email_dump = db.Column(db.UnicodeText())

    def address_str(self):
        # change list of addresses into a string to use as
        # query parameter
        return "(" + (" OR ").join(self.addresses) + ")"


class EmailAddress(db.Model):
    __tablename__ = "addresses"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    email_address = db.Column(db.String(255))


class Markov(db.Model):
    __tablename__ = "markovs"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    chain = db.Column(db.String(255))
    is_tweeted = db.Column(db.Boolean, default=False, nullable=False)
