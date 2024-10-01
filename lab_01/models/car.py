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
    
    @staticmethod
    def generateRandomCars(numCars, manufacturers):
        driveModes = ['awd', 'fwd', 'rwd', '4wd']
        bodyTypes = ['sedan', 'coupe', 'sport', 'wagon', 'hatchback', 'convertible', 'suv', 'minivan', 'pickup', 'crossover', 'offroader', 'van', 'roadster']
