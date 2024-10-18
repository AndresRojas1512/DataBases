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