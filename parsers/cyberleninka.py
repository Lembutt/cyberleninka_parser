import urllib
from . import base
from db_api import PublicationList, Publication

class CyberleninkaParser(base._Parser):
    """
            Call __init__ method with query as param of this class
        to start parsing.

        For example:

        >>> CyberleninkaParser('Python3, Парсинг')
    """
    URL = 'https://cyberleninka.ru/search?'

    def __init__(self, query):
        self.chrome = self.setup_chrome_wd()
        num_of_pages = self._get_number_of_pages(query)
        print(num_of_pages)
        self.pubs = self._parse(query, num_of_pages)

    def _get_number_of_pages(self, query):
        html = self.chrome.get_html(self.URL + urllib.parse.urlencode({'q': query}))
        bs = self.get_bs(html)
        num_of_pages = int(bs.find("h1", {"class": "bigheader"}).find('span').text.split(' ')[2].split('(')[0]) // 10
        if num_of_pages == 0:
            return 1
        if num_of_pages > 10:
            return 10
        return num_of_pages

    def _parse(self, query, num_of_pages):
        pubs = PublicationList()
        for page in range(1, num_of_pages+1):
            url = self.URL + urllib.parse.urlencode({'q': query, 'page': page})
            print(url)
            html = self.chrome.get_html(url, wait=True)
            bs = self.get_bs(html)
            results = bs.find("ul", {"id": "search-results"}).findAll('li')
            for res in results:
                parsed_res_dict = {
                    'link': 'https://cyberleninka.ru' + res.findAll('a', href=True)[0]['href'],
                    'name': res.findAll('h2', {'class': 'title'})[0].text,
                    'authors': res.findAll('span')[0].text.split(', '),
                    'info': res.findAll('div')[0].text,
                    'year': res.findAll('span', {'class': 'span-block'})[0].text.split(' / ')[0],
                    'source_name': res.findAll('span', {'class': 'span-block'})[0].text.split(' / ')[1],
                    'source_link': 'https://cyberleninka.ru' + res.findAll('a', href=True)[1]['href'],
                    'resource': 'cyberleninka',
                    'query': query.split(',')
                }
                pubs.add(Publication(parsed_res_dict))
        return pubs

