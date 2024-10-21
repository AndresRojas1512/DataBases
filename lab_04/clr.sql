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
