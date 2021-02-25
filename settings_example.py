from settings_helper import EmailHandler, Settings
from settings_helper import Database, User

fake_user = User(
    name="Chloe",
    addresses=["chloe@fake.com", "chloe2@fake.com"],
    avatar_link=("/static/images/avatars/chloe.jpg"),
)

settings = Settings(
    app_name="email-analysis",
    database=Database("postgresql://localhost:5432/db_name"),
    flask_config=dict(
        CACHE_TYPE="simple",
        CONFIG_ENV="Development",
        CSRF_ENABLED=True,
        DEBUG=True,
        JS_FILENAME="http://localhost:8080/assets/build/app.bundle.js",  # react hot loader
        SECRET_KEY='you-will-never-guess',
    ),
    user_list=[fake_user],
    email_handler=EmailHandler(),
)
