COPY manufacturers(manufacturerName, headquarters, ceo, foundationYear, revenue)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/manufacturers.csv'
DELIMITER ','
CSV HEADER;

COPY dealers(dealerName, dealerAddress, phoneNumber, email, authorizationStatus)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/dealers.csv'
DELIMITER ','
CSV HEADER;

