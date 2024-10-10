from faker import Faker
import csv
import random
import psycopg2


class Car:
    def __init__(self, engineID, manufacturerID, modelName, bodyType, modelYear, modelWeight):
        self.engineID = engineID
        self.manufacturerID = manufacturerID
        self.modelName = modelName
        self.bodyType = bodyType
        self.modelYear = modelYear
        self.modelWeight = modelWeight
    
    def toCsv(self):
        return [self.engineID, self.manufacturerID, self.modelName, self.bodyType, self.modelYear, self.modelWeight]
    
    def __hash__(self):
        return hash((self.engineID, self.manufacturerID, self.modelName, self.bodyType, self.modelYear, self.modelWeight))
    
    def __eq__(self, other):
        return (self.engineID == other.engineID and
                self.manufacturerID == other.manufacturerID and
                self.modelName == other.modelName and
                self.bodyType == other.bodyType and
                self.modelYear == other.modelYear and
                self.modelWeight == other.modelWeight)
    
def generateCars(numCars, engineIDs, manufacturerIDs):
    faker = Faker()
    bodyTypes = ['Sedan', 'Coupe', 'Hatchback', 'Convertible', 'Wagon', 'Pickup', 'SUV', 'Van']
    carsSet = set()
    cars = []

    while len(cars) < numCars:
        engineID = random.choice(engineIDs)
        manufacturerID = random.choice(manufacturerIDs)
        modelName = faker.word().capitalize()
        bodyType = random.choice(bodyTypes)
        modelYear = random.randint(1886, 2024)
        modelWeight = random.randint(800, 3000)

        car = Car(engineID, manufacturerID, modelName, bodyType, modelYear, modelWeight)
        if car not in carsSet:
            cars.append(car)
            carsSet.add(car)
        
    return cars

def saveToCsv(cars, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['engineID', 'manufacturerID', 'modelName', 'bodyType', 'modelYear', 'modelWeight'])
        for car in cars:
            writer.writerow(car.toCsv())

def fetchIDs(query, connection_details):
    conn = psycopg2.connect(**connection_details)
    cursor = conn.cursor()
    cursor.execute(query)
    ids = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return ids

if __name__ == "__main__":
    connection_details = {
        'dbname' : 'cars01',
        'user' : 'postgres',
        'password' : 'andresrmlnx15',
        'host' : 'localhost'
    }

    engineIDs = fetchIDs("SELECT engineID FROM engines", connection_details)
    manufacturerIDs = fetchIDs("SELECT manufacturerID FROM manufacturers", connection_details)
    cars = generateCars(1000, engineIDs, manufacturerIDs)
    saveToCsv(cars, 'cars.csv')