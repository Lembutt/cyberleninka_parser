from bs4 import BeautifulSoup as BS
from webdrivers import ChromeWebDriver

class _Parser:
    def setup_chrome_wd(self):
        return ChromeWebDriver()

    def get_bs(self, html):
        return BS(html, 'html.parser')


