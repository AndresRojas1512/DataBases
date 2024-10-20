from faker import Faker
import csv
import random
import psycopg2

fake = Faker()
materials = ['Aluminium', 'Steel', 'Iron', 'Plastic', 'Carbon fiber']
component_words = [
    "Piston", "Rod", "Valve", "Cover", "Cylinder", "Head", "Gasket", "Bolt", "Shaft", "Cam",
    "Gear", "Chain", "Seal", "Bearing", "Block", "Crankshaft", "Injector", "Pump", "Turbo", "Filter",
    "Exhaust", "Manifold", "Clutch", "Flywheel", "Compressor", "Cooler", "Radiator", "Fan", "Pulley", "Thermostat",
    "Sensor", "Control", "Nozzle", "Spark", "Plug", "Wiring", "Coil", "Belt", "Sprocket", "Plate",
    "Spring", "Tensioner", "Hose", "Bracket", "Mount", "Cover", "Arm", "Regulator", "Pipe", "Housing",
    "Alternator", "Carburetor", "Throttle", "Ignition", "Reservoir", "Injector", "Pump", "Solenoid", "Differential", "Stator",
    "Rotor", "Flywheel", "Oxygen", "Catalyst", "Converter", "Damper", "Disc", "Propeller", "Muffler", "Actuator",
    "Accumulator", "Servo", "Transmission", "Drive", "Linkage", "Joint", "Coupler", "Reducer", "Timing", "Guide",
    "Idler", "Ring", "Sleeve", "Spindle", "Support", "Bracket", "Clamp", "Expansion", "Adapter", "Turbine",
    "Retainer", "Vane", "Blade", "Bush", "Casing", "Tube", "Cradle", "Stand", "Baffle", "Spacer"
]

class Component:
    def __init__(self, componentName, engineId, parentComponentId, material):
        self.componentName = componentName
        self.engineId = engineId
        self.parentComponentId = parentComponentId
        self.material = material
    
    def toList(self):
        return [self.componentName, self.engineId, self.parentComponentId, self.material]

def generateRandomComponentName():
    word1 = random.choice(component_words)
    word2 = random.choice(component_words)
    return f"{word1} {word2}"
    
def generateRandomComponent(engineIds, parentComponentId=None):
    componentName = generateRandomComponentName()
    engineId = random.choice(engineIds)
    material = random.choice(materials)
    return Component(componentName, engineId, parentComponentId, material)


def generateComponentsData(amount, engineIds):
    components = []
    for _ in range(amount):
        parentComponentId = random.choice(enginesIds + [None])
        component = generateRandomComponent(engineIds, parentComponentId)
        components.append(component)
    return components

def writeToCsv(components, filePath):
    with open(filePath, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['component_name', 'engine_id', 'parent_component_id', 'material'])
        for component in components:
            writer.writerow(component.toList())

def fetchIds(query, connection_details):
    conn = psycopg2.connect(**connection_details)
    cursor = conn.cursor()
    cursor.execute(query)
    ids = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return ids
    
if __name__ == "__main__":
    connectionDetails = {
        'dbname' : 'cars01',
        'user' : 'postgres',
        'password' : 'andresrmlnx15',
        'host' : 'localhost'
    }
    enginesIds = fetchIds("SELECT engine_id FROM engines", connectionDetails)
    file = 'components.csv'
    components = generateComponentsData(1000, enginesIds)
    writeToCsv(components, file)

    