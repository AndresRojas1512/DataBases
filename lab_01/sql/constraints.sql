ALTER TABLE manufacturers
    ADD CONSTRAINT pk_manufacturer_id PRIMARY KEY(manufacturer_id),
    ADD CONSTRAINT unique_name UNIQUE (manufacturer_name),
    ADD CONSTRAINT check_foundation_year CHECK (foundation_year >= 1886 AND foundation_year <= 2024),
    ADD CONSTRAINT check_revenue CHECK (revenue >= 0),
    ALTER COLUMN manufacturer_name SET NOT NULL,
    ALTER COLUMN headquarters SET NOT NULL,
    ALTER COLUMN foundation_year SET NOT NULL,
    ALTER COLUMN ceo SET NOT NULL;

ALTER TABLE dealers
    ADD CONSTRAINT pk_dealer_id PRIMARY KEY(dealer_id),
    ADD CONSTRAINT unique_dealer_name UNIQUE (dealer_name),
    ADD CONSTRAINT check_authorization_status CHECK (authorization_status IN ('Authorized', 'Pending', 'Revoked', 'Suspended', 'Inactive')),
    ALTER COLUMN dealer_name SET NOT NULL,
    ALTER COLUMN dealer_address SET NOT NULL,
    ALTER COLUMN phone_number SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN authorization_status SET NOT NULL;

ALTER TABLE engines
    ADD CONSTRAINT pk_engine_id PRIMARY KEY(engine_id),
    ALTER COLUMN engine_type SET NOT NULL,
    ALTER COLUMN displacement SET NOT NULL,
    ALTER COLUMN fuel_type SET NOT NULL,
    ALTER COLUMN horsepower SET NOT NULL,
    ALTER COLUMN torque SET NOT NULL,
    ALTER compression_ratio SET NOT NULL,
    ALTER valve_configuration SET NOT NULL,
    ALTER turbo_charged SET NOT NULL,
    ALTER fuel_system SET NOT NULL,
    ADD CONSTRAINT check_displacement CHECK (displacement > 0),
    ADD CONSTRAINT check_horsepower CHECK (horsepower > 0),
    ADD CONSTRAINT check_torque CHECK (torque > 0),
    ADD CONSTRAINT check_compression_ratio_range CHECK (compression_ratio BETWEEN 5.0 AND 20.0),
    ADD CONSTRAINT check_engine_type CHECK (engine_type IN ('Inline', 'V', 'Flat', 'Rotary')),
    ADD CONSTRAINT check_fuel_type CHECK (fuel_type IN ('Gasoline', 'Diesel', 'Electric', 'Hybrid')),
    ADD CONSTRAINT check_fuel_system CHECK (fuel_system IN ('Direct Injection', 'Port Injection', 'Carbureted'));

ALTER TABLE cars
    ADD CONSTRAINT pk_car_id PRIMARY KEY(car_id),
    ADD CONSTRAINT fk_cars_engine_id FOREIGN KEY (engine_id) REFERENCES engines(engine_id),
    ADD CONSTRAINT fk_cars_manufacturer_id FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id),
    ADD CONSTRAINT check_year CHECK (model_year > 1885 AND model_year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    ADD CONSTRAINT check_weight_positive CHECK (model_weight > 0),
    ALTER COLUMN engine_id SET NOT NULL,
    ALTER COLUMN manufacturer_id SET NOT NULL,
    ALTER COLUMN model_name SET NOT NULL,
    ALTER COLUMN body_type SET NOT NULL,
    ALTER COLUMN model_year SET NOT NULL,
    ALTER COLUMN model_weight SET NOT NULL;

ALTER TABLE sales
    ADD CONSTRAINT pk_sale_id PRIMARY KEY(sale_id),
    ADD CONSTRAINT fk_sale_dealer_id FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id),
    ADD CONSTRAINT fk_sale_car_id FOREIGN KEY (car_id) REFERENCES cars(car_id),
    ALTER COLUMN dealer_id SET NOT NULL,
    ALTER COLUMN car_id SET NOT NULL,
    ALTER COLUMN sell_date SET NOT NULL,
    ALTER COLUMN price SET NOT NULL,
    ADD CONSTRAINT check_price CHECK (price >= 0),
    ADD CONSTRAINT check_sale_date CHECK (sell_date <= CURRENT_DATE);

ALTER TABLE dealersmanufacturers
    ADD CONSTRAINT pk_id PRIMARY KEY (id),
    ADD CONSTRAINT fk_dealer_id FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id),
    ADD CONSTRAINT fk_manufacturer_id FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id);

ALTER TABLE components
    ADD CONSTRAINT pk_component_id PRIMARY KEY (component_id),
    ADD CONSTRAINT fk_engine_id FOREIGN KEY (engine_id) REFERENCES engines (engine_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_parent_component FOREIGN KEY (parent_component_id) REFERENCES components (component_id) ON DELETE CASCADE,
    ALTER COLUMN component_name SET NOT NULL,
    ALTER COLUMN engine_id SET NOT NULL,
    ADD CONSTRAINT unique_component_name_per_engine UNIQUE (component_name, engine_id);
