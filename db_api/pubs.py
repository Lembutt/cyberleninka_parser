import json
import config
from . import postgres


class Publication:
    def __init__(self, data: dict):
        for k, v in data.items():
            if type(v) == type([]):
                for i in range(len(v)):
                    self.__dict__[k] = v[i].replace("'", "___")
            else:
                self.__dict__[k] = v.replace("'", "___")

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

    def insert_into_db(self):
        conf = config.Config()
        for pub in self.list:
            pub_json = json.dumps(pub.__dict__, ensure_ascii=False)
            query = f"""
                select * 
                from {conf.db_schema}.fn_pub_add_texts('{pub_json}');
            """
            try:
                res = postgres.Database().query(query)
            except Exception as e:
                print(e)
