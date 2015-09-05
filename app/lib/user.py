class User():
    def __init__(self,
                 name,
                 canonical_file,
                 pruned_file,
                 markov_file,
                 addresses,):
        self.name = name
        self.canonical_file = canonical_file
        self.pruned_file = pruned_file
        self.markov_file = markov_file
        self.addresses = addresses
        self.recipient_list = None

    def get_recipients(self):
        if self.recipient_list is None:
            print "Note: no recipients for %s defined" % self.name
            return ''
        return (" AND ").join(self.recipient_list)

    def address_str(self):
        # change list of addresses into a string to use as
        # query parameter
        return "(" + (" OR ").join(self.addresses) + ")"

    def query_all_messages_from(self):
        sender = self.address_str()
        recipients = self.get_recipients()

        return ("from:(%s) to: (%s) -label:chats" %
                (sender, recipients))

    def query_all_threads_from(self):
        sender = self.address_str()
        recipients = self.get_recipients()

        return ("from:(%s) to: (%s) -subject:(re:) -label:chats" %
                (sender, recipients))

    def count_number_of(self, str_to_match):
        try:
            with open(self.pruned_file, 'r') as file:
                text = file.read()
                if text is None:
                    return "Email file is empty. run save_files()"
                return text.count(str_to_match)
        except:
            print "file %s doesn't exist" % self.pruned_file
