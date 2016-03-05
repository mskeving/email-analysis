import os

if __name__ == "__main__":
    config_env = os.environ.get('CONFIG_ENV', 'Development')

    from app import create_app
    create_app(config_env).run()
