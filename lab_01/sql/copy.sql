COPY manufacturers(manufacturerName, headquarters, ceo, foundationYear, revenue)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/manufacturers.csv'
DELIMITER ','
CSV HEADER;

COPY dealers(dealerName, dealerAddress, phoneNumber, email, authorizationStatus)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/dealers.csv'
DELIMITER ','
CSV HEADER;

COPY engines(engineType, fuelType, valveConfiguration, fuelSystem, displacement, horsepower, torque, compressionRatio, turbocharged)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/engines.csv'
DELIMITER ','
CSV HEADER;

COPY cars(engineID, manufacturerID, modelName, bodyType, modelYear, modelWeight)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/cars.csv'
DELIMITER ','
CSV HEADER;

COPY sales(dealerID, carID, sellDate, price, warrantyPeriod, paymentMethod)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/sales.csv'
DELIMITER ','
CSV HEADER;