-- scalar function
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

-- stored procedure without parameters
DROP PROCEDURE IF EXISTS get_components_summary;

CREATE OR REPLACE PROCEDURE get_components_summary()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    RAISE NOTICE 'Engine ID | Number of Components';
    FOR rec IN
        SELECT engine_id, COUNT(*) AS num_components
        FROM components
        GROUP BY engine_id
    LOOP
        RAISE NOTICE '% | %', rec.engine_id, rec.num_components;
    END LOOP;
END;
$$;

CALL get_components_summary();

-- stored procedure with parameters
DROP PROCEDURE IF EXISTS update_engine_specs;

CREATE OR REPLACE PROCEDURE update_engine_specs(
    engine_id_param INT,
    horsepower_decrease INT,
    torque_increase INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM engines WHERE engine_id = engine_id_param) THEN
        UPDATE engines
        SET
            horsepower = GREATEST(horsepower - horsepower_decrease, 100),
            torque = torque + torque_increase
        WHERE
            engine_id = engine_id_param;
        
        RAISE NOTICE 'Engine % updated: hp decreased by=%, torque increased by=%', engine_id_param, horsepower_decrease, torque_increase;
    ELSE
        RAISE EXCEPTION 'error: %d engine not found', engine_id_param;
    END IF;
END;
$$

CALL update_engine_specs(2, 20, 30);
SELECT * from engines WHERE engine_id = 1;
SELECT * from engines WHERE engine_id = 2;

-- stored procedure with recursive CTE
DROP PROCEDURE IF EXISTS delete_engine_components;

CREATE OR REPLACE PROCEDURE delete_engine_components(engine_id_param INT)
LANGUAGE plpgsql
AS $$
BEGIN
    WITH RECURSIVE component_hierarchy AS (
        SELECT component_id, parent_component_id
        FROM components
        WHERE engine_id = engine_id_param
        
        UNION ALL

        SELECT c.component_id, c.parent_component_id
        FROM components c
        INNER JOIN component_hierarchy ch ON c.parent_component_id = ch.component_id
    )
    DELETE FROM components
    WHERE component_id IN (SELECT component_id FROM component_hierarchy);

    RAISE NOTICE 'Components for engine % and their sub-components deleted.', engine_id_param;
END;
$$;

CALL delete_engine_components(190);
SELECT * FROM components WHERE engine_id = 190;

-- stored procedure with cursor
DROP PROCEDURE IF EXISTS adjust_engine_horsepower;

CREATE OR REPLACE PROCEDURE adjust_engine_horsepower()
LANGUAGE plpgsql
AS $$
DECLARE
    engines_cursor CURSOR FOR
        SELECT engine_id, displacement, horsepower
        FROM engines;
    engine_record RECORD;
BEGIN
    OPEN engines_cursor;
    LOOP
        FETCH engines_cursor INTO engine_record;
        EXIT WHEN NOT FOUND;

        IF engine_record.displacement > 3000 THEN
            UPDATE engines
            SET horsepower = horsepower * 1.10
            WHERE engine_id = engine_record.engine_id;
            RAISE NOTICE 'engine=%, increased hp=%', engine_record.engine_id, engine_record.horsepower * 1.10;
        
        ELSIF engine_record.displacement <= 2000 THEN
            UPDATE engines
            SET horsepower = horsepower * 0.95
            WHERE engine_id = engine_record.engine_id;
            RAISE NOTICE 'engine=%, decresed hp=%d', engine_record.engine_id, engine_record.horsepower * 0.95;
        END IF;
    END LOOP;

    CLOSE engines_cursor;
END;
$$;

CALL adjust_engine_horsepower();

SELECT engine_id, displacement, horsepower
FROM engines
ORDER BY displacement;
