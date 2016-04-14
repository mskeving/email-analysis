from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.cache import Cache
from flask.ext.login import LoginManager

from settings import settings

SQLALCHEMY_DATABASE_URI = settings.database.url

app = Flask(__name__, template_folder='static/templates')
app.config.from_object(__name__)  # add capitalized variables above to config
app.config.update(settings.flask_config)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
app.cache = Cache(app)
db = SQLAlchemy(app)

login_manager = LoginManager()
login_manager.init_app(app)
# if a user attempts to view a page while not logged in,
# they'll be redirected to /login
login_manager.login_view = 'login'


def create_app(config="Production"):
    # note: config was originally coming in as "Development" or "Production"
    # which would denote what settings to use. Now we're getting all our config
    # info from settings.py, so we don't need this anymore. But removing it
    # breaks something on heroku, so I'm leaving it for now as Production mode.
    db.init_app(app)
    return app


def create_db(app):
    db.init_app(app)
    db.drop_all()
    db.create_all()


from app import models, views
