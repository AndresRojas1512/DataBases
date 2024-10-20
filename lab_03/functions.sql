-- Scalar function
DROP FUNCTION IF EXISTS average_horsepower_by_manufacturer(INT);
CREATE OR REPLACE FUNCTION average_horsepower_by_manufacturer(input_manufacturer_id INT)
RETURNS FLOAT AS $$
DECLARE
    avg_horsepower FLOAT;
BEGIN
    SELECT AVG(E.horsepower)
    INTO avg_horsepower
    FROM engines E
    JOIN cars C ON E.engine_id = C.engine_id
    WHERE C.manufacturer_id = input_manufacturer_id;
    
    RETURN COALESCE(avg_horsepower, 0);
END;
$$ LANGUAGE plpgsql;
SELECT average_horsepower_by_manufacturer(2);

CREATE OR REPLACE FUNCTION is_dealer_authorized(input_dealer_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    status VARCHAR(100);
BEGIN
    SELECT authorization_status INTO status
    FROM dealers
    WHERE dealer_id = input_dealer_id;

    RETURN (status = 'Authorized');
END;
$$ LANGUAGE plpgsql;
SELECT is_dealer_authorized(3);

-- set returning function
CREATE OR REPLACE FUNCTION list_cars_with_engines(input_manufacturer_id INT)
RETURNS TABLE (
    car_id INT,
    model_name VARCHAR,
    engine_type VARCHAR,
    horsepower INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        C.car_id,
        C.model_name,
        E.engine_type,
        E.horsepower
    FROM
        cars C
    JOIN
        engines E ON C.engine_id = E.engine_id
    WHERE
        C.manufacturer_id = input_manufacturer_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM list_cars_with_engines(1);

-- multi-statement set returning function
DROP FUNCTION IF EXISTS get_engines_by_torque_and_hp;

CREATE OR REPLACE FUNCTION get_engines_by_torque_and_hp(min_torque INT, min_hp INT)
RETURNS TABLE(
    engine_id INT,
    engine_type VARCHAR,
    fuel_type VARCHAR,
    valve_configuration VARCHAR,
    fuel_system VARCHAR,
    displacement INT,
    horsepower INT,
    torque INT,
    compression_ratio DECIMAL,
    turbo_charged BOOLEAN
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.engine_id,
        e.engine_type,
        e.fuel_type,
        e.valve_configuration,
        e.fuel_system,
        e.displacement,
        e.horsepower,
        e.torque,
        e.compression_ratio,
        e.turbo_charged
    FROM
        engines e
    WHERE
        e.torque >= min_torque
    
    INTERSECT

    SELECT
        e.engine_id,
        e.engine_type,
        e.fuel_type,
        e.valve_configuration,
        e.fuel_system,
        e.displacement,
        e.horsepower,
        e.torque,
        e.compression_ratio,
        e.turbo_charged
    FROM
        engines e
    WHERE
        e.horsepower >= min_hp;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_engines_by_torque_and_hp(400, 400);

-- recursive function using cte
DROP FUNCTION IF EXISTS get_component_hierarchy;

CREATE OR REPLACE FUNCTION get_component_hierarchy(input_engine_id INT)
RETURNS TABLE(
    component_id INT,
    component_name VARCHAR,
    parent_component_id INT,
    material VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE component_hierarchy AS (
        SELECT
            C.component_id,
            C.component_name,
            C.parent_component_id,
            C.material
        FROM
            components C
        WHERE
            C.engine_id = input_engine_id
            AND C.parent_component_id IS NULL

        UNION ALL

        SELECT
            C.component_id,
            C.component_name,
            C.parent_component_id,
            C.material
        FROM
            components C
        INNER JOIN component_hierarchy CH ON CH.component_id = C.parent_component_id
    )
    SELECT * FROM component_hierarchy;
END;
$$ LANGUAGE plpgsql


SELECT * FROM get_component_hierarchy(377);