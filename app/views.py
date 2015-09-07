from app import app, db
from flask import render_template, request
from lib.markov_generator import make_chain
from models import Markov, User

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/markov')
def markov():
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
            'username': user.name,
            'obj': new_markov
        })

    return render_template('markov.jade', markovs=markovs)

@app.route('/get_markov', methods=['POST'])
def get_markov():
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
