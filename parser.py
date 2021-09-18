import urllib
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from bs4 import BeautifulSoup as BS

class _ChromeWebDriver:
    def __init__(self):
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        self.wd = webdriver.Chrome(options=chrome_options)
    
    def get_html(self, url, wait:bool = False):
        self.wd.get(url)
        if wait:
            delay = 3 # seconds
            try:
                myElem = WebDriverWait(self.wd, delay).until(EC.presence_of_element_located((By.ID, 'search-results')))
                print("Page is ready!")
            except TimeoutException:
                print("Loading took too much time!")
        html = self.wd.page_source
        return html

        

class _Parser:
    def setup_wd(self):
        return _ChromeWebDriver()
    
    def get_bs(self, html):
        return BS(html, 'html.parser')

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

class CyberleninkaParser(_Parser):
    """
            Call __init__ method with query as param of this class
        to start parsing.

        For example:

        >>> Parser('Python3, Парсинг')
    """
    URL = 'https://cyberleninka.ru/search?'

    def __init__(self, query):
        self.chrome = self.setup_wd()
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
                    'source': res.findAll('span', {'class': 'span-block'})[0].text.split(' / ')[1],
                    'journal_link': 'https://cyberleninka.ru' + res.findAll('a', href=True)[1]['href']
                }
                pubs.add(Publication(parsed_res_dict))
        return pubs

if __name__ == '__main__':
    print('Please, enter your query here:')
    query = input()
    pubs = CyberleninkaParser(query).pubs
    print(pubs.count())
