from parsers.cyberleninka import CyberleninkaParser

if __name__ == '__main__':
    print('Please, enter your query here:')
    query = input()
    pubs = CyberleninkaParser(query).pubs
    print(pubs.count())
    pubs.insert_into_db()
