from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException


class ChromeWebDriver:
    def __init__(self):
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        self.wd = webdriver.Chrome(options=chrome_options)

    def get_html(self, url, wait: bool = False):
        self.wd.get(url)
        if wait:
            delay = 3  # seconds
            try:
                myElem = WebDriverWait(self.wd, delay).until(EC.presence_of_element_located((By.ID, 'search-results')))
                print("Page is ready!")
            except TimeoutException:
                print("Loading took too much time!")
        html = self.wd.page_source
        return html