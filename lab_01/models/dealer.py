from faker import Faker
import csv
import random

class Dealer:
    def __init__(self, dealerName, dealerAddress, phoneNumber, email, authorizationStatus):
        self.dealerName = self.clean_data(dealerName)
        self.dealerAddress = self.clean_data(dealerAddress)
        self.phoneNumber = self.clean_data(phoneNumber)
        self.email = self.clean_data(email)
        self.authorizationStatus = authorizationStatus
    
    def to_csv(self):
        return [self.dealerName, self.dealerAddress, self.phoneNumber, self.email, self.authorizationStatus]
    
    def clean_data(self, data):
        cleaned_data = data.replace('\n', ' ').replace('\r', ' ')
        cleaned_data = cleaned_data.replace('"', '').replace("'", "")
        return cleaned_data.strip()

def generate_dealers(num_dealers):
    faker = Faker()
    statuses = ['Authorized', 'Pending', 'Revoked', 'Suspended', 'Inactive']
    dealers = []
    used_names = set()

    while len(dealers) < num_dealers:
        dealerName = faker.company()
        if dealerName in used_names:
            continue
        dealerAddress = faker.address()
        phoneNumber = faker.phone_number()
        email = faker.email()
        authorizationStatus = random.choice(statuses)
        
        dealer = Dealer(dealerName, dealerAddress, phoneNumber, email, authorizationStatus)
        dealers.append(dealer)
        used_names.add(dealerName)

    return dealers

def save_to_csv(dealers, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['dealerName', 'dealerAddress', 'phoneNumber', 'email', 'authorizationStatus'])
        for dealer in dealers:
            writer.writerow(dealer.to_csv())

if __name__ == "__main__":
    dealers = generate_dealers(1000)
    save_to_csv(dealers, 'dealers.csv')
