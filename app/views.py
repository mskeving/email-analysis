import json

from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from models import Markov, User


@app.route('/')
def index():
    return render_template('index.jade')


@app.route('/line')
def my_line_chart():
    return render_template('base.jade', js_filename='linechart.bundle.js')


@app.route('/stats', methods=['GET'])
def stats():
    return render_template('base.jade', js_filename='stats.bundle.js')


@app.route('/stats/get_message_count', methods=['GET'])
def get_message_count():
    '''For each user, get the total number of messages they have sent'''
    all_users = User.query.all()
    data = []
    for u in all_users:
        data.append({'x': u.name, 'y': u.message_count()})

    return json.dumps(data)


@app.route('/stats/get_count', methods=['GET'])
def get_count():
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


@app.route('/markov', methods=['GET'])
def markov():
    return render_template('base.jade', js_filename='skarkov.bundle.js')


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
    user_name = request.form.get('user_name', None)
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
    markov_id = request.form.get('markov_id', None)
    markov = Markov.query.filter_by(id=markov_id).one()

    if not markov:
        return "no markov found"

    markov.is_tweeted = True
    db.session.commit()

    return "success"
