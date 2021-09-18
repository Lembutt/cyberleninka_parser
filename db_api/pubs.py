class Publication:
    def __init__(self, data: dict):
        self.__dict__ = data

    def get_str(self):
        return f'{self.name}, {self.authors}'

class PublicationList:
    def __init__(self):
        self.list = []

    def add(self, pub: Publication):
        self.list.append(pub)

    def get_str(self):
        text = ''
        for pub in self.list:
            text += pub.get_str + '\n'

    def count(self):
        return len(self.list)
