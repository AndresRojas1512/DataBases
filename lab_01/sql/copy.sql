COPY manufacturers(manufacturer_name, headquarters, ceo, foundation_year, revenue)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/manufacturers.csv'
DELIMITER ','
CSV HEADER;

COPY dealers(dealer_name, dealer_address, phone_number, email, authorization_status)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/dealers.csv'
DELIMITER ','
CSV HEADER;

COPY engines(engine_type, fuel_type, valve_configuration, fuel_system, displacement, horsepower, torque, compression_ratio, turbo_charged)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/engines.csv'
DELIMITER ','
CSV HEADER;

COPY cars(engine_id, manufacturer_id, model_name, body_type, model_year, model_weight)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/cars.csv'
DELIMITER ','
CSV HEADER;

COPY sales(dealer_id, car_id, sell_date, price, warranty_period, payment_method)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/sales.csv'
DELIMITER ','
CSV HEADER;

COPY dealersManufacturers(dealer_id, manufacturer_id)
FROM '/home/andres/Desktop/5Semester/DataBases/DataBases/lab_01/models/dealersManufacturers.csv'
DELIMITER ','
CSV HEADER