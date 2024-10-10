import csv
import random
import psycopg2

class DealerManufacturer:
    def __init__(self, dealerID, manufacturerID):
        self.dealerID = dealerID
        self.manufacturerID = manufacturerID
    
    def toCsv(self):
        return [self.dealerID, self.manufacturerID]
    
def generateDealerManufacturerPairs(dealerIDs, manufacturerIDs):
    pairs = []
    for dealerID in dealerIDs:
        numManufacturers = random.randint(1,5)
        chosenManufacturers = random.sample(manufacturerIDs, numManufacturers)
        for manufacturerID in chosenManufacturers:
            pair = DealerManufacturer(dealerID, manufacturerID)
            pairs.append(pair)
    return pairs

def fetchIDs(query, connection_details):
    conn = psycopg2.connect(**connection_details)
    cursor = conn.cursor()
    cursor.execute(query)
    ids = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return ids

def saveToCsv(pairs, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['dealerID', 'manufacturerID'])
        for pair in pairs:
            writer.writerow(pair.toCsv())

if __name__ == "__main__":
    connection_details = {
        'dbname' : 'cars01',
        'user' : 'postgres',
        'password' : 'andresrmlnx15',
        'host' : 'localhost'
    }

    dealerIDs = fetchIDs("SELECT dealerID FROM dealers", connection_details)
    manufacturerIDs = fetchIDs("SELECT manufacturerID FROM manufacturers", connection_details)
    pairs = generateDealerManufacturerPairs(dealerIDs, manufacturerIDs)
    saveToCsv(pairs, 'dealersManufacturers.csv')