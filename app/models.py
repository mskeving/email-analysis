from app import db

class Example(db.Model):
    __tablename__ = "example"

    id = db.Column(db.Integer, primary_key=True)
