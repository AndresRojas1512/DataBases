ALTER TABLE manufacturers
    ADD CONSTRAINT uniqueName UNIQUE (manufacturerName),
    ADD CONSTRAINT checkFoundationYear CHECK (foundationYear >= 1886 AND foundationYear <= 2024),
    ADD CONSTRAINT checkRevenue CHECK (revenue >= 0),
    ALTER COLUMN manufacturerName SET NOT NULL,
    ALTER COLUMN headquarters SET NOT NULL,
    ALTER COLUMN foundationYear SET NOT NULL,
    ALTER COLUMN ceo SET NOT NULL;

ALTER TABLE dealers
    ADD CONSTRAINT uniqueDealerName UNIQUE (dealerName),
    ADD CONSTRAINT checkAuthorizationStatus CHECK (authorizationStatus IN ('Authorized', 'Pending', 'Revoked', 'Suspended', 'Inactive')),
    ALTER COLUMN dealerName SET NOT NULL,
    ALTER COLUMN dealerAddress SET NOT NULL,
    ALTER COLUMN phoneNumber SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN authorizationStatus SET NOT NULL;

ALTER TABLE cars
    ADD CONSTRAINT fkCarsEngineID FOREIGN KEY (engineID) REFERENCES engines(engineID),
    ADD CONSTRAINT fkCarsManufacturerID FOREIGN KEY (manufacturerID) REFERENCES manufacturers(manufacturerID),
    ADD CONSTRAINT checkYear CHECK (modelYear > 1885 AND modelYear <= EXTRACT(YEAR FROM CURRENT_DATE)),
    ADD CONSTRAINT checkWeightPositive CHECK (modelWeight > 0),
    ALTER COLUMN engineID SET NOT NULL,
    ALTER COLUMN manufacturerID SET NOT NULL,
    ALTER COLUMN modelName SET NOT NULL,
    ALTER COLUMN bodyType SET NOT NULL,
    ALTER COLUMN modelYear SET NOT NULL,
    ALTER COLUMN modelWeight SET NOT NULL

ALTER TABLE engines
    ALTER COLUMN engineType SET NOT NULL,
    ALTER COLUMN displacement SET NOT NULL,
    ALTER COLUMN fuelType SET NOT NULL,
    ALTER COLUMN horsepower SET NOT NULL,
    ALTER COLUMN torque SET NOT NULL,
    ALTER compressionRatio SET NOT NULL,
    ALTER valveConfiguration SET NOT NULL,
    ALTER turbocharged SET NOT NULL,
    ALTER fuelSystem SET NOT NULL,
    ADD CONSTRAINT checkDisplacement CHECK (displacement > 0),
    ADD CONSTRAINT checkHorsepower CHECK (horsepower > 0),
    ADD CONSTRAINT checkTorque CHECK (torque > 0),
    ADD CONSTRAINT checkCompressionRatioRange CHECK (compressionRatio BETWEEN 5.0 AND 20.0),
    ADD CONSTRAINT checkEngineType CHECK (engineType IN ('Inline', 'V', 'Flat', 'Rotary')),
    ADD CONSTRAINT checkFuelType CHECK (fuelType IN ('Gasoline', 'Diesel', 'Electric', 'Hybrid')),
    ADD CONSTRAINT checkFuelSystem CHECK (fuelSystem IN ('Direct Injection', 'Port Injection', 'Carbureted'));

ALTER TABLE sales
    ADD CONSTRAINT fkSellsDealerID FOREIGN KEY (dealerID) REFERENCES dealers(dealerID),
    ADD CONSTRAINT fkSellsCardID FOREIGN KEY (carID) REFERENCES cars(carID),
    ALTER COLUMN dealerID SET NOT NULL,
    ALTER COLUMN carID SET NOT NULL,
    ALTER COLUMN sellDate SET NOT NULL,
    ALTER COLUMN price SET NOT NULL,
    ADD CONSTRAINT checkPrice CHECK (price >= 0),
    ADD CONSTRAINT checkSellDate CHECK (sellDate <= CURRENT_DATE);