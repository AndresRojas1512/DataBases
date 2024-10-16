-- 1 comparision predicate
SELECT
    C.model_name,
    C.model_year,
    M.manufacturer_name,
    M.foundation_year
FROM
    cars C
JOIN
    manufacturers M ON C.manufacturer_id = M.manufacturer_id
WHERE
    C.model_year > M.foundation_year
ORDER BY
    M.manufacturer_name, C.model_year;

-- 2 between predicate
SELECT DISTINCT
    sale_id,
    sell_date,
    dealer_id,
    car_id,
    price
FROM
    sales
WHERE
    sell_date BETWEEN '2023-01-01' AND '2023-03-31'
ORDER BY
    sell_date;

-- 3 like predicate
SELECT DISTINCT
    model_name,
    body_type,
    manufacturer_id
FROM
    cars
WHERE
    model_name LIKE '%SUV'
ORDER BY
    model_name;

-- 4 in predicate with a nested subquery
SELECT
    sale_id,
    dealer_id,
    car_id,
    sell_date,
    price
FROM
    sales
WHERE
    dealer_id IN(
        SELECT
            dealer_id
        FROM
            dealers
        WHERE
            dealer_address LIKE '%NY%' OR dealer_address LIKE '%LA%'
    )
ORDER BY
    sell_date;

-- 5 exist predicate with a nested subquery
SELECT
    engine_id,
    engine_type
FROM
    engines
WHERE EXISTS (
    SELECT
        1
    FROM
        cars C
    WHERE
        C.engine_id = engines.engine_id AND C.model_year > 2015
);

-- 6 comparision predicate with a quantifier
SELECT
    car_id,
    model_name,
    model_weight
FROM
    cars
WHERE
    model_weight > ALL (
        SELECT
            model_weight
        FROM
            cars
        WHERE
            manufacturer_id = 1
);

-- 7 aggregate functions
SELECT
    AVG(total_price) AS actual_avg,
    SUM(total_price) / COUNT(sale_id) AS calc_avg
FROM (
    SELECT
        sale_id,
        SUM(price) AS total_price
    FROM
        sales
    GROUP BY
        sale_id
) AS total_sales

-- 8 scalar subqueries
SELECT
    D.dealer_id,
    D.dealer_name,
    (SELECT COUNT(DISTINCT manufacturer_id)
    FROM
        dealersmanufacturers
    WHERE
        dealer_id = D.dealer_id) AS num_manufacturers
FROM
    dealers D

-- 9 simple CASE expression
SELECT
    car_id,
    model_name,
    model_weight,
    CASE
        WHEN model_weight < 1500 THEN 'Light'
        WHEN model_weight BETWEEN 1500 AND 2500 THEN 'Medium'
        WHEN model_weight > 2500 THEN 'Heavy'
        ELSE 'Undefined'
    END AS weight_class
FROM
    cars;

-- 10 select instruction that uses case search expression
SELECT
    sale_id,
    car_id,
    price,
    CASE
        WHEN price < 20000 THEN 'Economy'
        WHEN price BETWEEN 20000 AND 40000 THEN 'Mid-range'
        WHEN price > 40000 THEN 'Premium'
        ELSE 'Undefined'
    END AS price_category
FROM
    sales;

-- 11 create a new table from the resulting data set of a select instruction
CREATE TABLE engine_summary AS
SELECT
    engine_type,
    AVG(horsepower) AS avg_horsepower,
    AVG(torque) AS total_torque,
    COUNT(engine_id) AS engine_count
FROM
    engines
GROUP BY
    engine_type;
SELECT * FROM engine_summary;

-- 12 
