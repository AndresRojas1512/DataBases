import csv
import random

class Manufacturer:
    def __init__(self, manufacturerName, headquarters, foundationDate, ceo, revenue):
        self.manufacturerName = manufacturerName
        self.headquarters = headquarters
        self.foundationDate = foundationDate
        self.ceo = ceo
        self.revenue = revenue