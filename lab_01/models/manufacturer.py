from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from faker import Faker
import random
import csv
import time
import os

class Manufacturer:
    def __init__(self, manufacturerName, headquarters, foundationDate, ceo, revenue):
        self.manufacturerName = manufacturerName
        self.headquarters = headquarters
        self.foundationDate = foundationDate
        self.ceo = ceo
        self.revenue = revenue

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

        file_exists = os.path.exists(output_file)
        mode = 'a' if file_exists else 'w'

        with open(output_file, mode, newline='') as file:
            writer = csv.writer(file)
            if not file_exists:
                writer.writerow(['Name', 'foundationDate'])
            writer.writerows(brands)

        print(f"Total brands fetched and saved: {len(brands)}")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        driver.quit()

def rearrange_columns(input_file, output_file):
    with open(input_file, mode='r', newline='') as infile:
        reader = csv.DictReader(infile)
        fieldnames = ['name', 'country', 'foundationDate']
        
        with open(output_file, mode='w', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for row in reader:
                writer.writerow({
                    'name': row['name'],
                    'country': row['country'],
                    'foundationDate': row['foundationDate']
                })

def add_ceo_column(input_file, output_file):
    fake = Faker()
    with open(input_file, mode='r', newline='') as infile:
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames + ['ceo']
        
        with open(output_file, mode='w', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            for row in reader:
                row['ceo'] = fake.name_male()
                writer.writerow(row)

def add_revenue_column(input_file, output_file):
    fake = Faker()

    with open(input_file, mode='r', newline='') as infile:
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames + ['revenue']
        
        with open(output_file, mode='w', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            for row in reader:
                row['revenue'] = random.randint(1, 100) * 1000000000
                writer.writerow(row)

def rearrange_columns(input_file, output_file):
    with open(input_file, mode='r', newline='') as infile:
        reader = csv.DictReader(infile)
        fieldnames = ['name', 'country', 'ceo', 'foundationDate', 'revenue']
        
        with open(output_file, mode='w', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for row in reader:
                new_row = {
                    'name': row['name'],
                    'country': row['country'],
                    'ceo': row['ceo'],
                    'foundationDate': row['foundationDate'],
                    'revenue': row['revenue']
                }
                writer.writerow(new_row)


def fix_foundation_dates(input_file):
    with open(input_file, mode='r', newline='') as infile:
        reader = csv.DictReader(infile)
        # writer = csv.DictWriter(outfile, fieldnames=reader.fieldnames)
        # writer.writeheader()
        
        for row in reader:
            try:
                year = int(row['foundationDate'])  # Convert the foundation date to an integer
                if year < 1886 or year > 2024:
                    # raise ValueError  # Trigger the error handling to assign a new year
                    print(f"Out of range: {row}")
            except ValueError:
                # row['foundationDate'] = random.randint(1886, 2024)
                print(f"Invalid value: {row}")
            # finally:
            #     writer.writerow(row)

if __name__ == "__main__":
    input_file = 'manufacturers.csv'
    output_file = 'manufacturersMod.csv'
    # url = "https://www.car.info/en-se/brands?country=VN&view=list_row&order=brand_name"

    # fetch_car_brands(url, output_file)
    # rearrange_columns(input_file, output_file)
    # add_ceo_column(input_file, output_file)
    # add_revenue_column(input_file, output_file)
    # rearrange_columns(input_file, output_file)
    fix_foundation_dates(input_file)