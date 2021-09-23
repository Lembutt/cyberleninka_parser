import json
import config
from . import postgres


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

    def insert_into_db(self):
        conf = config.Config()
        json_data = [json.dumps(pub.__dict__, ensure_ascii=False).replace("'","''") for pub in self.list]        
        print(json_data)
        query = f"""
        select * 
        from {conf.db_schema}.fn_pub_add_texts(ARRAY{json_data});"""
        postgres.Database().query(query)
        
