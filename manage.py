from app import app, create_db


def initdb():
    # Note: calling this will drop everything in db
    create_db(app)

if __name__ == '__main__':
    initdb()
