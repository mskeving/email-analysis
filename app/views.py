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
    chains = []

    for user in users:
        chain = make_chain(user)
        new_markov = Markov(user_id=user.id, chain=chain)
        db.session.add(new_markov)
        chains.append({
            'name': user.name,
            'chain': chain
        })

    db.session.commit()

    return render_template('markov.jade', chains=chains)

@app.route('/get_markov', methods=['POST'])
def get_markov(user_name=None):
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
