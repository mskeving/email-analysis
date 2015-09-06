import json
from random import randint


def choose_rand_from_list(l):
    if len(l) == 0:
        return None
    else:
        return l[randint(0, len(l)-1)]


def make_chain(user):
    text_list = []
    starter_words = [tuple(w) for w in json.loads(user.markov_starter_words)]
    # the keys are nested json so you need to do .loads() twice
    # look at update_db_data.save_markov_info to see how it's stored
    markov_dict = json.loads(user.markov_dict)
    markov_dict = {tuple(json.loads(k)): v for k, v in markov_dict.iteritems()}

    if not starter_words or not markov_dict:
        return "Error: %s is missing the markov_dict or starter words" % user.name

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
