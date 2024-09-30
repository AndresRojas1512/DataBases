CREATE TABLE IF NOT EXISTS manufacturers (
    manufacturerID SERIAL PRIMARY KEY,
    manufacturerName VARCHAR(100),
    headquarters VARCHAR(100),
    foundationDate DATE,
    ceo VARCHAR(100),
    revenue INT
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
    modelWeight INT,
    driveMode VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS engines (
    engineID SERIAL PRIMARY KEY,
    engineType VARCHAR(100),
    displacement INT,
    fuelType VARCHAR(100),
    fuelConsumption INT,
    horsepower INT,
    torque INT,
    compressionRatio DECIMAL,
    valveConfiguration VARCHAR(100),
    turboCharged BOOLEAN,
    fuelSystem VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS sells (
    sellID SERIAL PRIMARY KEY,
    dealerID INT,
    carID INT,
    sellDate DATE,
    price INT,
    specialConditions VARCHAR(100)
);
