import json
import requests


ANALYSIS_URL = "http://text-processing.com/api/sentiment/"


def get_users_counts(user):
    labels = {
        'pos': 0,
        'neg': 0,
        'neutral': 0,
        'unknown': 0,
    }

    for msg in user.messages:
        label = get_label(msg.pruned)
        if label:
            labels[label] += 1

    return labels


def get_label(text):
    r = requests.post(ANALYSIS_URL, data={'text': text})

    try:
        results = json.loads(r.content)

        label = results['label']

    except:
        label = "unknown"

    return label
