from collections import namedtuple
from flask.ext.login import UserMixin

from app import login_manager
from settings import settings


class LoginUser(UserMixin):
    # proxy for a database of users
    Login = namedtuple('Login', 'username password')
    user_database = {
        "general": Login(
            settings.general_credentials.username,
            settings.general_credentials.password
        ),
        "admin": Login(
            settings.admin_credentials.username,
            settings.admin_credentials.password
        ),
    }

    def __init__(self, username, password):
        self.id = username
        self.password = password

    @classmethod
    def get(cls, id):
        return cls.user_database.get(id)


@login_manager.user_loader
def load_user(username):
    credentials = LoginUser.get(username)
    if credentials:
        return LoginUser(username=credentials.username,
                         password=credentials.password)
    return None
