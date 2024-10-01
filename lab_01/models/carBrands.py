from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import NoSuchElementException
import time
import csv

def fetch_car_brands(url):
    service = Service('/usr/bin/chromedriver')
    driver = webdriver.Chrome(service=service)

    try:
        driver.get(url)
        time.sleep(5)

        last_height = driver.execute_script("return document.body.scrollHeight")
        while True:
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(5)
            new_height = driver.execute_script("return document.body.scrollHeight")
            if new_height == last_height:
                break
            last_height = new_height

        brand_elements = driver.find_elements(By.CLASS_NAME, "brand_item")
        brands = [brand.text for brand in brand_elements]
        print(f"Total brands fetched: {len(brands)}")

        for brand in brands:
            print(brand)
        
        return brands

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        driver.quit()

url = "https://www.car.info/en-se/brands?country=AD&view=list_row&order=brand_name"
fetch_car_brands(url)
