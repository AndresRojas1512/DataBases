CREATE TABLE IF NOT EXISTS manufacturers (
    manufacturerID SERIAL PRIMARY KEY,
    manufacturerName VARCHAR(100),
    headquarters VARCHAR(100),
    ceo VARCHAR(100),
    foundationYear INT,
    revenue BIGINT
);

CREATE TABLE IF NOT EXISTS dealers (
    dealerID SERIAL PRIMARY KEY,
    dealerName VARCHAR(100),
    dealerAddress VARCHAR(100),
    phoneNumber VARCHAR(100),
    email VARCHAR(100),
    authorizationStatus VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS cars (
    carID SERIAL PRIMARY KEY,
    engineID INT,
    manufacturerID INT,
    modelName VARCHAR(100),
    bodyType VARCHAR(100),
    modelYear INT,
    modelWeight INT
);

CREATE TABLE IF NOT EXISTS engines (
    engineID SERIAL PRIMARY KEY,
    engineType VARCHAR(100),
    fuelType VARCHAR(100),
    valveConfiguration VARCHAR(100),
    fuelSystem VARCHAR(100),
    displacement INT,
    horsepower INT,
    torque INT,
    compressionRatio DECIMAL,
    turbocharged BOOLEAN
);

CREATE TABLE IF NOT EXISTS sales (
    sellID SERIAL PRIMARY KEY,
    dealerID INT,
    carID INT,
    sellDate DATE,
    price INT,
    warrantyPeriod INT,
    paymentMethod VARCHAR(100)
);
