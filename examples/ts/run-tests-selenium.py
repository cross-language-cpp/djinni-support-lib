#! /usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import sys
import time
import threading

port = "8050"
httpd = HTTPServer(("127.0.0.1", int(port)), SimpleHTTPRequestHandler)

def run_server():
    print("Serving HTTP on localhost port " + port + " (http://localhost:" + port + "/) ...")
    httpd.serve_forever()

server_thread = threading.Thread(target=run_server)
server_thread.start()

service = Service(executable_path=r'/usr/bin/chromedriver')
options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--disable-gpu')
driver = webdriver.Chrome(service=service, options=options)
print(f"connecting web driver to http://localhost:{port}/")
driver.get(f"http://localhost:{port}/demo.html")
asc_button = driver.find_element(By.ID, "btnAsc")
desc_button = driver.find_element(By.ID, "btnDesc")

asc_button.click()
print("Wait for Asc button press")
time.sleep(0.5)
value =  driver.find_element(By.ID, "txt").get_attribute("value")
is_ascending_ok = value == "item1\nitem2\nitem3\nitem4\nitem5"
print(f"text area on Sort Asc pressed:\n{value}")
desc_button.click()
print("Wait for Desc button press")
time.sleep(0.5)
value = driver.find_element(By.ID, "txt").get_attribute("value")
print(f"text area on Sort Desc pressed:\n{value}")
is_descending_ok = value == "item5\nitem4\nitem3\nitem2\nitem1"

driver.quit()
httpd.shutdown()
server_thread.join()
if is_ascending_ok and is_descending_ok:
    exit(0)
print(f"is_ascending_ok = {is_ascending_ok}")
print(f"is_descending_ok = {is_descending_ok}")
exit(1)
