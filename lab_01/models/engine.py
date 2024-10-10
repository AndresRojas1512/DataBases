from faker import Faker
import csv
import random

class Engine:
    def __init__(self, engineType, fuelType, valveConfiguration, fuelSystem, displacement, horsepower, torque, compressionRatio, turboCharged):
        self.engineType = engineType
        self.fuelType = fuelType
        self.valveConfiguration = valveConfiguration
        self.fuelSystem = fuelSystem
        self.displacement = displacement
        self.horsepower = horsepower
        self.torque = torque
        self.compressionRatio = compressionRatio
        self.turboCharged = turboCharged
    
    def toCsv(self):
        return [self.engineType, self.fuelType, self.valveConfiguration, self.fuelSystem, self.displacement, self.horsepower, self.torque, self.compressionRatio, self.turboCharged]
    
    def __hash__(self):
        return hash((self.engineType, self.fuelType, self.valveConfiguration, self.fuelSystem, self.displacement, self.horsepower, self.torque, self.compressionRatio, self.turboCharged))
    
    def __eq__(self, other):
        return (
            self.engineType == other.engineType and
            self.fuelType == other.fuelType and
            self.valveConfiguration == other.valveConfiguration and
            self.fuelSystem == other.fuelSystem and
            self.displacement == other.displacement and
            self.horsepower == other.horsepower and
            self.torque == other.torque and
            self.compressionRatio == other.compressionRatio and
            self.turboCharged == other.turboCharged
        )

def generateEngines(numEngines):
    engines = []
    engineTypes = ['Inline', 'V', 'Flat', 'Rotary']
    fuelTypes = ['Gasoline', 'Diesel', 'Electric', 'Hybrid']
    valveConfigurations = ['OHV', 'OHC', 'DOHC']
    fuelSystems = ['Direct Injection', 'Port Injection', 'Carbureted']
    turboChargedOptions = [1, 0]
    enginesSet = set()
    engines = []

    while len(engines) < numEngines:
        engine = Engine(
            engineType=random.choice(engineTypes),
            fuelType=random.choice(fuelTypes),
            valveConfiguration=random.choice(valveConfigurations),
            fuelSystem=random.choice(fuelSystems),
            displacement=random.randint(1000, 4000),
            horsepower=random.randint(100, 600),
            torque=random.randint(100, 500),
            compressionRatio=random.randint(5, 20),
            turboCharged=random.choice(turboChargedOptions)
        )
        if engine not in enginesSet:
            engines.append(engine)
            enginesSet.add(engine)
    return engines

def saveToCsv(engines, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Engine Type', 'fuelType', 'valveConfiguration', 'fuelSystem', 'displacement', 'horsepower', 'torque', 'compressionRatio', 'turboCharged'])
        for engine in engines:
            writer.writerow(engine.toCsv())

if __name__ == "__main__":
    engines = generateEngines(1000)
    saveToCsv(engines, 'engines.csv')