import requests
import urllib
from . import base
from db_api import PublicationList, Publication
import config

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
        if num_of_pages > config.Config().max_pages:
            return config.Config().max_pages
        return num_of_pages

    def _parse(self, query, num_of_pages):
        pubs = PublicationList()
        for page in range(1, num_of_pages+1):
            url = self.URL + urllib.parse.urlencode({'q': query, 'page': page})
            html_list = self.chrome.get_html(url, wait=True)
            bs_list = self.get_bs(html_list)
            results = bs_list.find("ul", {"id": "search-results"}).findAll('li')
                
            for res in results:
                try:        
                    link = 'https://cyberleninka.ru' + res.findAll('a', href=True)[0]['href']
                    html_article = requests.get(link).text
                    bs_article = self.get_bs(html_article)
                    parsed_res_dict = {
                        'link': link,
                        'name': res.findAll('h2', {'class': 'title'})[0].text,
                        'authors': res.findAll('span')[0].text.split(', '),
                        'info': res.findAll('div')[0].text,
                        'year': res.findAll('span', {'class': 'span-block'})[0].text.split(' / ')[0],
                        'source_name': res.findAll('span', {'class': 'span-block'})[0].text.split(' / ')[1],
                        'source_link': 'https://cyberleninka.ru' + res.findAll('a', href=True)[1]['href'],
                        'resource': 'cyberleninka',
                        'query': query.split(','),
                        'text': bs_article.find("div", {"class": "ocr", "itemprop": "articleBody"}).get_text()
                    }

                    if bs_article.find("i", {"itemprop": "keywords"}) is not None:
                        kwords_tagged = bs_article.find("i", {"itemprop": "keywords"}).findAll("span")
                        kwords = [kwords_tagged[i].text for i in range(len(kwords_tagged))]
                    else:
                        kwords = []

                    parsed_res_dict['keywords'] = kwords

                    if bs_article.find("div", {"class": "labels"}) is not None:
                        labels_tagged = bs_article.find("div", {"class": "labels"}).findAll("div", "label")
                        labels = [labels_tagged[i].text for i in range(1, len(labels_tagged))]
                    else:
                        labels = []

                    parsed_res_dict['status'] = labels
                    print(labels)

                    if bs_article.find("p", {"itemprop": "description"}) is not None:
                        annotation = bs_article.find("p", {"itemprop": "description"}).text
                    else:
                        annotation = ""
                
                    parsed_res_dict['annotation'] = annotation

                    pubs.add(Publication(parsed_res_dict))
                except Exception as e:
                    print('exeption!', e)
                    pass
        return pubs

