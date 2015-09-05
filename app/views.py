from app import app, db
from flask import render_template, request
from lib.markov_generator import get_chain
from models import Markov, User

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/markov')
def markov():
    # defualt to missy on page load
    chain = get_chain(1)

    return render_template('markov.html', chain=chain)

@app.route('/get_markov', methods=['POST'])
def get_markov(user_name=None):
    form = request.form
    user_name = form.get('user_name', 'missy')
    user = User.query.filter_by(name=user_name).first()
    chain = get_chain(user.id)

    new_markov = Markov(user_id=user.id, chain=chain)
    db.session.add(new_markov)
    db.session.commit()

    return chain
