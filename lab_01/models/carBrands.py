from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import csv
import time

def fetch_car_brands(url, output_file):
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
        brands = []
        for element in brand_elements:
            parts = element.text.split('\n')
            if len(parts) > 1:
                brand_name = parts[0]
                foundation_year = parts[1].strip(' -')
            else:
                brand_name = parts[0]
                foundation_year = 'Unknown'

            brands.append((brand_name, foundation_year))

        # Write to CSV
        with open(output_file, 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['Name', 'foundationDate'])
            writer.writerows(brands)

        print(f"Total brands fetched and saved: {len(brands)}")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        driver.quit()

url = "https://www.car.info/en-se/brands?country=AR&view=list_row&order=brand_name"
output_file = "car_brands.csv"
fetch_car_brands(url, output_file)
