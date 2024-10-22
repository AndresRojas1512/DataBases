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
