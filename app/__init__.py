from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy

SQLALCHEMY_DATABASE_URI = "postgresql://localhost:5432/email"
DEBUG = True
SECRET_KEY = 'development-key'
app = Flask(__name__, template_folder='static/templates')
app.config.from_object(__name__) # add all capitalized variables to config
db = SQLAlchemy(app)

def create_app(config):
    app.config.from_object('config.flask.' + config)
    db.init_app(app)
    return app

def create_db(app):
    db.init_app(app)
    db.drop_all()
    db.create_all()

from app import models, views
