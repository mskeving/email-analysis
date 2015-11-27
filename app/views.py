import json

from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from models import Markov, User

@app.route('/')
def index():
    return render_template('index.jade')

@app.route('/stats', methods=['GET'])
def stats():
    return render_template('base.jade', js_filename='stats.bundle.js')

@app.route('/stats/get_count', methods=['GET'])
def get_count():
    all_users = User.query.all()
    string_to_match = request.args.get('string_to_match')
    if not string_to_match:
        return json.dumps({})
    data = {'values':[]}
    for u in all_users:
        data['values'].append({'x': u.name, 'y': u.count_number_of(string_to_match)})
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
