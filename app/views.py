import json
from sqlalchemy import asc
from flask import render_template, request, redirect
from flask.ext.login import (login_user, logout_user,
                             current_user, login_required)

from app import app, db
from lib.markov_generator import make_chain
from lib.helper import convert_unix_to_readable, capitalize
from lib.helper import seconds_to_time
from login import LoginUser, load_user
from models import Markov, User, Message, DatabaseImport


@app.route('/login', methods=['GET'])
def login():
    if current_user.is_authenticated:
        return redirect('/')

    return render_template('base.jade',
                           js_filename=app.config['LOGIN_JS_FILENAME'])


@app.route('/submit_login', methods=['POST'])
def submit_login():
    next = request.args.get('next')
    username = request.form.get('username')
    password = request.form.get('password')

    # Note: this (dumb) strategy of login allows you to only login with
    # your general credentials. Need to refactor this to allow other usernames.
    general_user = LoginUser.get('general')

    if (username == general_user.username and
            password == general_user.password):

        user = load_user(general_user.username)
        if user:
            login_user(user)
            return json.dumps({'message': "success"})

    return json.dumps({'message': "Invalid Credentials"})


@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect('/login')


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
@login_required
def catch_all(path):
    # react-router is used on the client to take care of routing.
    # This is a catch-all url to say - whatever url we put in,
    # render base.jade with app js and the client takes care of the rest.
    return render_template('base.jade',
                           js_filename=app.config['APP_JS_FILENAME'])


@app.route('/facts', methods=['POST'])
@app.cache.cached(timeout=60)
@login_required
def facts():
    ''' This is where we query for any needed info for our facts list
    on the homepage. Returns a list of facts in json.
    '''
    # fact: total number of messages sent
    num_messages = len(Message.query.all())

    # fact: the first message's date and sender
    first_msg = Message.query.order_by(asc(Message.send_time_unix)).first()
    first_msg_timestamp = convert_unix_to_readable(first_msg.send_time_unix)
    first_msg_sender = User.query.filter_by(id=first_msg.sender_user_id).first()

    # fact: longest thread's length and subject
    longest_thread_subject, longest_thread_length = Message.longest_thread_subject_length()

    # fact: fastest response time
    fastest_responder = User.fastest_responder()
    fr_name = capitalize(fastest_responder.name)
    fr_time = seconds_to_time(fastest_responder.avg_response_time())

    facts = [
        'Number of emails between us: {}'.format(num_messages),
        'First message sent: {} by {}'.format(
            first_msg_timestamp, capitalize(first_msg_sender.name)),
        'Longest thread: "{}" with {} messages'.format(
            longest_thread_subject, longest_thread_length),
        'Fastest average response time: {} by {}'.format(
            fr_time, fr_name),
    ]

    return json.dumps({'facts': facts})


@app.route('/api/base', methods=['POST'])
@login_required
def get_base_data():
    """ This is the info we need to get to show on every page.
    For example, anything that needs to be in the header or footer
    """
    last_import = DatabaseImport.query.first()

    return json.dumps({'last_import': last_import.timestamp})


@app.route('/api/users', methods=['GET'])
@app.cache.cached(timeout=600)
@login_required
def get_users():
    user_info = [u.to_api_dict() for u in User.query.all()]

    return json.dumps(user_info)


@app.route('/stats/get_message_count', methods=['GET'])
@login_required
def get_message_count():
    '''For each user, get the total number of messages they have sent'''
    all_users = User.query.all()
    data = [{'x': u.name, 'y': u.message_count()} for u in all_users]

    return json.dumps(data)


@app.route('/stats/get_count', methods=['GET'])
@login_required
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
@login_required
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
@login_required
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
@login_required
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
