import json

from sqlalchemy import asc

from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from lib.helper import convert_unix_to_readable, add_commas
from models import Markov, User, Message, DatabaseImport

CACHE_TIMEOUT = 3600  # 1 hour


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    # react-router is used on the client to take care of routing.
    # This is a catch-all url to say - whatever url we put in,
    # render base.jade with app js and the client takes care of the rest.
    return render_template('base.jade', js_filename=app.config['JS_FILENAME'])


@app.route('/facts', methods=['POST'])
@app.cache.cached(timeout=CACHE_TIMEOUT)
def facts():
    ''' This is where we query for any needed info for our facts list
    on the homepage. Returns a list of facts in json.
    '''
    # fact: total number of messages sent
    num_messages = len(Message.query.all())
    num_messages = add_commas(num_messages)

    # fact: the first message's date and sender
    first_msg = Message.query.order_by(asc(Message.send_time_unix)).first()
    first_msg_timestamp = convert_unix_to_readable(first_msg.send_time_unix)

    # fact: longest thread's length and subject
    _, longest_thread_length = Message.longest_thread_subject_length()

    facts = [
        'Family members: 5',
        'First message: {}'.format(first_msg_timestamp),
        'Total emails: {}'.format(num_messages),
        'Longest thread: {}'.format(longest_thread_length),
    ]

    return json.dumps({'facts': facts})


@app.route('/api/base', methods=['POST'])
@app.cache.cached(timeout=CACHE_TIMEOUT)
def get_base_data():
    """ This is the info we need to get to show on every page.
    For example, anything that needs to be in the header or footer
    """
    last_import = DatabaseImport.query.first()

    return json.dumps({'last_import': last_import.timestamp})


@app.route('/api/users', methods=['GET'])
@app.cache.cached(timeout=CACHE_TIMEOUT)
def get_users():
    users = User.query.all()
    users = [u.to_api_dict() for u in users]

    return json.dumps(users)


@app.route('/stats/get_message_count', methods=['GET'])
@app.cache.cached(timeout=CACHE_TIMEOUT)
def get_message_count():
    '''For each user, get the total number of messages they have sent'''
    all_users = User.query.all()
    data = [{'x': u.name, 'y': u.message_count()} for u in all_users]

    return json.dumps(data)


@app.route('/stats/get_count', methods=['GET'])
def get_count():
    '''search for the number of times a user has typed a word'''
    string = request.args.get('string_to_match')
    if not string:
        return json.dumps({})

    data = {
        'usr_to_str_counts': [],
        'search_str': string
    }

    all_users = User.query.all()
    for u in all_users:
        # For each user, we need both x and y axis labels (user name and
        # word count, respectively). We're just showing case-insensitve results
        usr_to_str_counts = u.count_number_of(string)['case_insensitive']
        data['usr_to_str_counts'].append({'x': u.name, 'y': usr_to_str_counts})

    return json.dumps(data)


@app.route('/get_markovs', methods=['POST'])
def get_markovs():
    # on page load, get markov for every user
    users = User.query.all()
    markovs = []

    for user in users:
        chain = make_chain(user)
        new_markov = Markov(user_id=user.id, chain=chain)
        db.session.add(new_markov)
        db.session.commit()
        db.session.refresh(new_markov)
        markovs.append({
            'user_name': user.name,
            'markov_dict': new_markov.to_api_dict()
        })

    return json.dumps(markovs)


@app.route('/get_one_markov', methods=['POST'])
def get_one_markov():
    user_name = request.form.get('user_name')
    if not user_name:
        return "Error: No user name found"
    user = User.query.filter_by(name=user_name).first()
    chain = make_chain(user)

    new_markov = Markov(user_id=user.id, chain=chain)
    db.session.add(new_markov)
    db.session.commit()

    return json.dumps(new_markov.to_api_dict())


@app.route('/tweet', methods=['POST'])
def tweet():
    ''' keep track of the tweeted markovs so we can get an
    idea of what our success rate is compared to how many we
    generate'''
    markov_id = request.form.get('markov_id')
    markov = Markov.query.filter_by(id=markov_id).first()

    if not markov:
        return "no markov found"

    markov.is_tweeted = True
    db.session.commit()

    return "success"
