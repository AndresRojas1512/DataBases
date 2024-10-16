CREATE TABLE IF NOT EXISTS manufacturers (
    manufacturer_id SERIAL,
    manufacturer_name VARCHAR(100),
    headquarters VARCHAR(100),
    ceo VARCHAR(100),
    foundation_year INT,
    revenue BIGINT
);

CREATE TABLE IF NOT EXISTS dealers (
    dealer_id SERIAL,
    dealer_name VARCHAR(100),
    dealer_address VARCHAR(100),
    phone_number VARCHAR(100),
    email VARCHAR(100),
    authorization_status VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS cars (
    car_id SERIAL,
    engine_id INT,
    manufacturer_id INT,
    model_name VARCHAR(100),
    body_type VARCHAR(100),
    model_year INT,
    model_weight INT
);

CREATE TABLE IF NOT EXISTS engines (
    engine_id SERIAL,
    engine_type VARCHAR(100),
    fuel_type VARCHAR(100),
    valve_configuration VARCHAR(100),
    fuel_system VARCHAR(100),
    displacement INT,
    horsepower INT,
    torque INT,
    compression_ratio DECIMAL,
    turbo_charged BOOLEAN
);

CREATE TABLE IF NOT EXISTS sales (
    sale_id SERIAL,
    dealer_id INT,
    car_id INT,
    sell_date DATE,
    price INT,
    warranty_period INT,
    payment_method VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dealersmanufacturers (
    ID SERIAL,
    dealer_id INT,
    manufacturer_id INT
)