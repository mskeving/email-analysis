import json

from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from models import Markov, User

@app.route('/')
def index():
    return render_template('index.jade')

@app.route('/markov', methods=['GET'])
def markov():
    return render_template('markov_new.jade')

@app.route('/get_markovs', methods=['POST'])
def get_markovs():
    # on page load, get markov for every user
    users = User.query.all()
    markov_dict = {}

    for user in users:
        chain = make_chain(user)
        new_markov = Markov(user_id=user.id, chain=chain)
        # db.session.add(new_markov)
        # db.session.commit()
        # db.session.refresh(new_markov)
        markov_dict[user.name] = new_markov.to_api_dict()

    return json.dumps(markov_dict)

@app.route('/get_one_markov', methods=['POST'])
def get_one_markov():
    form = request.form
    user_name = form.get('user_name', None)
    if not user_name:
        return "Error: No user name found"
    user = User.query.filter_by(name=user_name).first()
    chain = make_chain(user)

    new_markov = Markov(user_id=user.id, chain=chain)
    db.session.add(new_markov)
    db.session.commit()

    return chain

@app.route('/tweet', methods=['POST'])
def tweet():
    markov_id = request.form.get('markov_id', None)
    markov = Markov.query.filter_by(id=markov_id)
    if not markov:
        return "no markov found"
    markov.is_tweeted = True
    db.session.commit()
    return "success"
