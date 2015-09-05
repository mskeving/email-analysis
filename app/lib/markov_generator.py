import nltk.data
from collections import defaultdict
from random import randint
from app.models import Message
from nltk.tokenize import word_tokenize


def find_starter_words(text):
    sent_detector = nltk.data.load('tokenizers/punkt/english.pickle')
    sentences = sent_detector.tokenize(text.strip())
    word_pairs = []
    for sentence in sentences:
        words = word_tokenize(sentence)
        if len(words) > 1:
            word_pairs.append((words[0], words[1]))
    return word_pairs


def choose_rand_from_list(l):
    if len(l) == 0:
        return None
    else:
        return l[randint(0, len(l)-1)]

def create_markov_dict(text):
    markov = defaultdict(list)
    words = word_tokenize(text)
    for i in xrange(len(words) - 2):
        current = words[i]
        next_word = words[i+1]
        prefix = (current, next_word)
        suffix = words[i + 2]
        if suffix not in markov[prefix]:
            markov[prefix].append(suffix)
    return markov

def make_chain(text):
    text_list = []

    starter_words = find_starter_words(text)
    markov_dict = create_markov_dict(text)
    current_word_pair = choose_rand_from_list(starter_words)
    next_word = choose_rand_from_list(markov_dict[current_word_pair])

    if not current_word_pair or not next_word:
        return "No markov created"
    text_list.extend([current_word_pair[0], current_word_pair[1], next_word])
    try:
        while next_word[-1] not in ['.', '?', '!', '"', ')', '\n']:
            current_word_pair = (current_word_pair[1], next_word)
            next_word = choose_rand_from_list(markov_dict[current_word_pair])
            text_list.append(next_word)
    except:
        pass

    return (' ').join(text_list)

def get_chain(user_id):
    messages = Message.query.filter_by(sender=user_id).all()
    if  not messages:
        return "No markov found for %r." % "Missy"

    text = (' ').join([m.pruned for m in messages if m.pruned])
    return make_chain(text)
