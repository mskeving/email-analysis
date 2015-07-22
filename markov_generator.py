from collections import defaultdict
from random import randint


def create_markov_dict(src):
    markov = defaultdict(list)
    word_list = src.split(' ')
    for i in xrange(len(word_list) - 2):
        current = word_list[i]
        next_word = word_list[i+1]
        prefix = (current, next_word)
        suffix = word_list[i + 2]
        if suffix not in markov[prefix]:
            markov[prefix].append(suffix)
    return markov


def choose_rand_from_list(l):
    ran = randint(0, len(l)-1)
    return l[ran]


def sanitize_text(text):
    """ remove things like parens, handle double spaces,
    double quotes"""
    pass


def make_chain(markov):
    text_list = []

    capitalized_word_pairs = []
    for word_pair in markov.keys():
        if word_pair[0].istitle():
            capitalized_word_pairs.append(word_pair)

    current_word_pair = choose_rand_from_list(capitalized_word_pairs)
    next_word = choose_rand_from_list(markov[current_word_pair])

    text_list.extend([current_word_pair[0], current_word_pair[1], next_word])
    try:
        while next_word[-1] not in ['.', '?', '!', '"', ')', '\n']:
            current_word_pair = (current_word_pair[1], next_word)
            next_word = choose_rand_from_list(markov[current_word_pair])
            text_list.append(next_word)
    except:
        pass

    return (' ').join(text_list)


def generate_and_save_markov(user):
    with open(user.pruned_messages, 'r') as file:
        data = file.read()
    file.close()

    markov_dict = create_markov_dict(data)
    markov_chain = make_chain(markov_dict)

    with open(user.markov_file, 'a') as file:
        file.write('\n\n')
        file.write(markov_chain)
    file.close()

    return markov_chain
