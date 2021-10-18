from parsers.cyberleninka import CyberleninkaParser
import db_api.postgres as pg

if __name__ == '__main__':
    print('get res or parse?')
    query = input()
    if query == 'get res' or query == 'res':
        res = pg.Database().get_counted()
        print(res.data_to_show)
    else:
        pubs = CyberleninkaParser(query).pubs
        print(pubs.count())
        pubs.insert_into_db()
    
