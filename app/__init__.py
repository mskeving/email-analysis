from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from settings import settings

SQLALCHEMY_DATABASE_URI = settings.database.url

app = Flask(__name__, template_folder='static/templates')
app.config.from_object(__name__)  # add all capitalized variables to config
app.config.from_object(settings.flask_config)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')

db = SQLAlchemy(app)


def create_app():
    db.init_app(app)
    return app


def create_db(app):
    db.init_app(app)
    db.drop_all()
    db.create_all()


from app import models, views
