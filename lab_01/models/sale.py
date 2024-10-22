from faker import Faker
import csv
import random
from datetime import timedelta, datetime
import psycopg2

class Sale:
    def __init__(self, dealerID, carID, sellDate, price, warrantyPeriod, paymentMethod):
        self.dealerID = dealerID
        self.carID = carID
        self.sellDate = sellDate
        self.price = price
        self.warrantyPeriod = warrantyPeriod
        self.paymentMethod = paymentMethod
    
    def __hash__(self):
        return hash((self.dealerID, self.carID, self.sellDate, self.price, self.warrantyPeriod, self.paymentMethod))
    
    def __eq__(self, other):
        return (self.dealerID == other.dealerID and
                self.carID == other.carID and
                self.sellDate == other.sellDate and
                self.price == other.price and
                self.warrantyPeriod == other.warrantyPeriod and
                self.paymentMethod == other.paymentMethod)
    
    def toCsv(self):
        return[self.dealerID, self.carID, self.sellDate.strftime('%Y-%m-%d'), self.price, self.warrantyPeriod, self.paymentMethod]

def generateSales(numSales, dealerIDs, carIDs):
    faker = Faker()
    salesSet = set()
    sales = []
    paymentMethods = ['Cash', 'Financing', 'Lease', 'Credit Card', 'Trade-In']

    while len(sales) < numSales:
        dealerID = random.choice(dealerIDs)
        carID = random.choice(carIDs)
        sellDate = faker.date_between(start_date='-2y', end_date='today')
        price = random.randint(5000, 500000)
        warrantyPeriod = random.choice([12, 24, 36, 48, 60])
        paymentMethod = random.choice(paymentMethods)

        sale = Sale(dealerID, carID, sellDate, price, warrantyPeriod, paymentMethod)
        if sale not in salesSet:
            sales.append(sale)
            salesSet.add(sale)
    
    return sales

def saveToCsv(sales, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['dealerID', 'carID', 'sellDate', 'price', 'warrantyPeriod', 'paymentMethod'])
        for sale in sales:
            writer.writerow(sale.toCsv())

def fetchIDs(query, connection_details):
    conn = psycopg2.connect(**connection_details)
    cursor = conn.cursor()
    cursor.execute(query)
    ids = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return ids

def generateVehicleIdentification(saleIds):
    faker = Faker()
    with open("vehicle_identification.csv", mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['sale_id', 'vin', 'licence', 'registration_country'])
        for saleId in salesIds:
            vin = faker.bothify(text='???#####???##???##')
            license_plate = faker.bothify(text='???-####')
            registration_country = faker.country()
            writer.writerow([saleId, vin, license_plate, registration_country])

if __name__ == "__main__":
    connection_details = {
        'dbname' : 'cars01',
        'user' : 'postgres',
        'password' : 'andresrmlnx15',
        'host' : 'localhost'
    }

    # dealerIDs = fetchIDs("SELECT dealerID FROM dealers", connection_details)
    # carIDs = fetchIDs("SELECT carID FROM cars", connection_details)
    # sales = generateSales(1000, dealerIDs, carIDs)
    # saveToCsv(sales, 'sales.csv')

    # vehicle identification
    salesIds = fetchIDs("SELECT sale_id FROM sales", connection_details)
    generateVehicleIdentification(salesIds)