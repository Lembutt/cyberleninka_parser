import json

CONFIG_FILE = '.config.json'
def get_local_config() -> dict:
    with open(file=CONFIG_FILE) as conf:
        config = json.load(conf)
    return config

class Config:
    def __init__(self):
        self.__dict__ = get_local_config()