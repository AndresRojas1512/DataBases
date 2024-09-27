CREATE TABLE IF NOT EXISTS manufacturers (
    manufacturerID SERIAL PRIMARY KEY,
    name VARCHAR(100),
    headquarters VARCHAR(100),
    founded DATE,
    ceo VARCHAR(100),
    revenue INT
);

CREATE TABLE IF NOT EXISTS dealers (
    dealerID SERIAL PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(100),
    phoneNumber INT,
    email VARCHAR(100),
    authorizationStatus VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS cars (
    carID SERIAL PRIMARY KEY,
    manufacturerID INT,
    modelName VARCHAR(100),
    year INT,
    bodyStyle VARCHAR(100),
    weight INT,
    fuelType VARCHAR(100),
    displacement INT,
    type VARCHAR(100),
    horsepower INT,
    torque INT,
    engineMaterial VARCHAR(100),
);

CREATE TABLE IF NOT EXISTS engines (
    engineID SERIAL PRIMARY KEY,
    compressionRatio NUMERIC,
    valveConfiguration VARCHAR(100),
    turboCharged BOOLEAN,
    fuelSystem VARCHAR(100),
    engineMaterial VARCHAR(100),
);

CREATE TABLE IF NOT EXISTS carEngineMappings (
    mappingID SERIAL PRIMARY KEY,
    carID INTEGER,
    engineID INTEGER,
    defaultEngine BOOLEAN,
    performanceVariant BOOLEAN,
    installationDate DATE,
    FOREIGN KEY (carID) REFERENCES cars(carID),
    FOREIGN KEY (engineID) REFERENCES engines(engineID)
);
