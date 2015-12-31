import json

from datetime import datetime
from collections import defaultdict

from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from models import Markov, User, Message


@app.route('/')
def index():
    return render_template('index.jade')


@app.route('/stats', methods=['GET'])
def stats():
    return render_template('base.jade', js_filename='stats.bundle.js')


@app.route('/stats/message_time_bargraph', methods=['GET'])
def message_time_bargraph():
    msgs = Message.query.all()
    year_to_messages = defaultdict(list)
    for m in msgs:
        year = datetime.fromtimestamp(int(m.send_time_unix)).strftime('%Y')
        year_to_messages[year].append(m)

    all_data = []
    for year, msgs in year_to_messages.iteritems():
        if year == '2008':
            continue
        year_data = {}

        user_to_count = {}
        for m in msgs:
            user_to_count[m.sender] = user_to_count.get(m.sender, 0) + 1

        values = []
        for user, count in user_to_count.iteritems():
            values.append({'x': user, 'y': count})
        year_data['label'] = year
        year_data['values'] = values
        all_data.append(year_data)

    return json.dumps(all_data)


@app.route('/stats/message_time_graph', methods=['GET'])
def message_time_graph():
    def sort_by_year(messages):
        data = []
        year_to_count = {}
        for m in messages:
            year = datetime.fromtimestamp(float(m.send_time_unix)).strftime('%Y')
            year_to_count[year] = year_to_count.get(year, 0) + 1

        for year, count in year_to_count.iteritems():
            data.append({'x': year, 'y': year_to_count[year]})
        sorted_by_year = sorted(data, key=lambda data: data['x'])
        return sorted_by_year

    data = []
    all_users = User.query.all()
    for u in all_users:
        messages = Message.query.filter_by(sender=u.id).order_by('send_time_unix').all()
        data.append({'label': u.name, 'values': sort_by_year(messages)})

    return json.dumps(data)


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


@app.route('/playground/brush')
def brush():
    return render_template('brush.html')


@app.route('/playground/grouped_barchart')
def grouped_barchart():
    return render_template('grouped_bar_chart.html')


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
