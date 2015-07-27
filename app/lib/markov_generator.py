import nltk.data
import codecs
from nltk.tokenize import word_tokenize
from collections import defaultdict
from random import randint


def create_markov_dict(src):
    markov = defaultdict(list)
    words = word_tokenize(src)
    for i in xrange(len(words) - 2):
        current = words[i]
        next_word = words[i+1]
        prefix = (current, next_word)
        suffix = words[i + 2]
        if suffix not in markov[prefix]:
            markov[prefix].append(suffix)
    return markov


def find_first_words_of_sentences(text):
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


def sanitize_text(text):
    """ remove things like parens, handle double spaces,
    double quotes"""
    pass


def make_chain(starting_word_pairs, markov):
    text_list = []

    current_word_pair = choose_rand_from_list(starting_word_pairs)
    next_word = choose_rand_from_list(markov[current_word_pair])

    if not current_word_pair or not next_word:
        return "No markov created"
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
    with codecs.open('data/' + user.pruned_file, encoding='utf-8', mode='r') as file:
        data = file.read()

    markov_dict = create_markov_dict(data)
    starting_word_pairs = find_first_words_of_sentences(data)
    markov_chain = make_chain(starting_word_pairs, markov_dict)

    with codecs.open('data/' + user.markov_file, encoding='utf-8', mode='a') as file:
        file.write('\n\n' + markov_chain)

    return markov_chain
