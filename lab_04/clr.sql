-- scalar function
DROP FUNCTION IF EXISTS max_sale_price_for_manufacturer;

CREATE OR REPLACE FUNCTION max_sale_price_for_manufacturer(manufacturer_id INT)
RETURNS INT AS $$
    query = """
    SELECT MAX(s.price) AS max_price
    FROM cars c
    JOIN sales s ON c.car_id = s.car_id
    WHERE c.manufacturer_id = %d
    """ % manufacturer_id

    result = plpy.execute(query)

    if result and result[0]['max_price'] is not None:
        return result[0]['max_price']
    else:
        return None
$$ LANGUAGE plpython3u;

SELECT * FROM max_sale_price_for_manufacturer(3);

-- aggregate function
DROP FUNCTION IF EXISTS get_avg_hp_to_weight_ratio;
CREATE OR REPLACE FUNCTION get_avg_hp_to_weight_ratio()
RETURNS FLOAT AS $$
    query = """
    SELECT c.body_type, SUM(e.horsepower) AS total_hp, SUM(c.model_weight) AS total_weight
    FROM cars c
    JOIN engines e ON c.engine_id = e.engine_id
    GROUP BY c.body_type;
    """
    results = plpy.execute(query)

    if results:
        ratios = [row['total_hp'] / row['total_weight'] if row['total_weight'] > 0 else 0 for row in results]
        return sum(ratios) / len(ratios) if ratios else 0
    else:
        return 0
$$ LANGUAGE plpython3u;

SELECT get_avg_hp_to_weight_ratio() AS avg_hp_to_weight_ratio;

-- user-defined table function
DROP FUNCTION IF EXISTS get_cars_by_body_type;

CREATE OR REPLACE FUNCTION get_cars_by_body_type(body_type VARCHAR)
RETURNS TABLE(model_name VARCHAR, engine_type VARCHAR, horsepower INT, model_year INT) AS $$
    query = """
    SELECT c.model_name, e.engine_type, e.horsepower, c.model_year
    FROM cars c
    JOIN engines e ON c.engine_id = e.engine_id
    WHERE c.body_type = %s;
    """ % plpy.quote_literal(body_type)
    cars = plpy.execute(query)
    return cars
$$ LANGUAGE plpython3u;

SELECT * FROM get_cars_by_body_type('Sedan');

-- stored procedure
DROP PROCEDURE IF EXISTS update_horsepower;

CREATE OR REPLACE PROCEDURE update_horsepower(min_model_year INT, increase_percentage FLOAT)
LANGUAGE plpython3u AS $$
    query="""
    UPDATE engines
    SET horsepower = horsepower * (1 + (%s / 100))
    WHERE engine_id IN (
        SELECT engine_id FROM cars WHERE model_year < %s
    );
    """ % (increase_percentage, min_model_year)
    plpy.execute(query)
    plpy.notice('cars older than:%s. Update by:%s%%' % (min_model_year, increase_percentage))
$$;

CALL update_horsepower(2010, 10);

-- trigger
CREATE TABLE IF NOT EXISTS authorization_status_audit (
    change_id SERIAL PRIMARY KEY,
    dealer_id INT,
    old_status VARCHAR(100),
    new_status VARCHAR(100),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP FUNCTION IF EXISTS log_authorization_status_change;

CREATE OR REPLACE FUNCTION log_authorization_status_change()
RETURNS TRIGGER AS $$
    if TD['new']['authorization_status'] != TD['old']['authorization_status']:
        query = """
        INSERT INTO authorization_status_audit(dealer_id, old_status, new_status)
        VALUES (%s, %s, %s);
        """ % (TD['new']['dealer_id'], plpy.quote_literal(TD['old']['authorization_status']), plpy.quote_literal(TD['new']['authorization_status']))
        plpy.execute(query)
    return 'MODIFY'
$$ LANGUAGE plpython3u;

CREATE TRIGGER trigger_log_authorization_status_change
AFTER UPDATE OF authorization_status ON dealers
FOR EACH ROW
EXECUTE FUNCTION log_authorization_status_change();

UPDATE dealers SET authorization_status = 'Suspended' WHERE dealer_id = 1;
SELECT * FROM authorization_status_audit;