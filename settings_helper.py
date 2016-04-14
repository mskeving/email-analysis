import os

base_dir = os.path.abspath(os.path.dirname(__file__))


class Settings(object):
    def __init__(self,
                 app_name,
                 database,
                 flask_config,
                 user_list,
                 email_handler,
                 general_credentials=None,
                 admin_credentials=None,
                 ):
        self.app_name = app_name
        self.database = database
        self.flask_config = flask_config
        self.user_list = user_list
        self.email_handler = email_handler
        self.general_credentials = general_credentials
        self.admin_credentials = admin_credentials


class Database(object):
    def __init__(self, url):
        self.url = url


class LoginCredentials(object):
    def __init__(self, username, password):
        self.username = username
        self.password = password


class HerokuDatabase(Database):
    def __init__(self):
        url = os.environ.get('DATABASE_URL')
        if url is None or len(url) == 0:
            raise Exception("Missing environment variable \"DATABASE_URL\".");
        super(HerokuDatabase, self).__init__(url)


class User(object):
    def __init__(self, name, addresses, avatar_link):
        self.name = name
        self.addresses = addresses
        self.avatar_link = avatar_link

    def address_str(self):
        # change list of addresses into a string to use as
        # query parameter
        return "(" + (" OR ").join(self.addresses) + ")"


class EmailHandler(object):
    def __init__(self):
        pass

    def prune_junk_from_message(self, message):
        ''' There's a lot of junk in emails, like signatures and
        quoted replies. This takes out a lot of that so you're
        left with the actual message someone typed.
        '''
        black_list = ['>',
                      'On Sun,',
                      'On Sun,'
                      'On Mon,'
                      'On Tue,',
                      'On Wed,',
                      'On Thu,',
                      'On Fri,',
                      'On Sat,',
                      'From: ',
                      'Envoy',  # envoye de mon iphone
                      'Re: ',
                      '***********************',
                      ]
        pruned_message = ''
        for line in message.split('\r\n\r\n'):
            if line.startswith(tuple(black_list)):
                break
            line += ' '  # to put a space where \r\n\r\n used to be
            new = line.replace('\r\n', ' ')  # recent gmail uses this for line formatting
            new = new.replace('\n\n', ' ')  # earlier gmail users this for paragraph breaks
            new = new.replace('\n', ' ')  # earlier gmail users this for line formatting (nice paragraphs)
            pruned_message += new
        return pruned_message
