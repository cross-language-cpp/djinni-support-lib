#! /usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import sys
import threading

port = 8089
httpd = HTTPServer(("127.0.0.1", int(port)), SimpleHTTPRequestHandler)

def run_server():
    print("Serving HTTP on localhost port " + port + " (http://localhost:" + port + "/) ...")
    httpd.serve_forever()

server_thread = threading.Thread(target=run_server)
server_thread.start()

service = Service(executable_path=r'/usr/bin/chromedriver')
options = webdriver.ChromeOptions()
#options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--disable-gpu')
driver = webdriver.Chrome(service=service, options=options)
print(f"connecting web driver to http://localhost:{port}/")
driver.get(f"http://localhost:{port}/test.html")
#element = driver.find_element(By.NAME, "query")
#assert element.is_enabled()
driver.quit()
finished_tests = True
httpd.shutdown()
server_thread.join()
