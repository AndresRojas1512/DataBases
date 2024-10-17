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
SELECT
    engine_type,
    AVG(horsepower) AS avg_horsepower,
    AVG(torque) AS avg_torque,
    COUNT(engine_id) AS engine_count
INTO
    engine_summary
FROM
    engines
GROUP BY
    engine_type;
SELECT * FROM engine_summary;

-- 12 select instruction that uses nested correlated subqueries
SELECT 
    C.model_name,
    C.model_year,
    derived_sales_data.total_sales,
    derived_sales_data.avg_sale_price
FROM 
    cars C
JOIN (
    SELECT 
        S.car_id, 
        COUNT(*) AS total_sales,
        AVG(S.price) AS avg_sale_price,
        C.manufacturer_id
    FROM 
        sales S
    JOIN 
        cars C ON S.car_id = C.car_id
    GROUP BY 
        S.car_id, C.manufacturer_id
) AS derived_sales_data ON C.car_id = derived_sales_data.car_id
WHERE 
    C.manufacturer_id = derived_sales_data.manufacturer_id;

-- 13 nested subqueries with nesting level 3
SELECT
    'by units' AS criteria,
    model_name AS "best selling",
    total_sales
FROM
    cars
JOIN (
    SELECT
        car_id,
        sales_count AS total_sales
    FROM (
        SELECT
            car_id,
            sales_count,
            ROW_NUMBER() OVER (ORDER BY sales_count DESC) AS rn
        FROM (
            SELECT
                car_id,
                COUNT(*) AS sales_count
            FROM
                sales
            GROUP BY
                car_id
        ) AS sub_query_level_2
    ) AS sub_query_level_1
    WHERE rn = 1
) AS top_selling ON top_selling.car_id = cars.car_id;

-- 14 select instruction with GROUP BY, but without HAVING
SELECT
    fuel_type,
    AVG(displacement) AS average_displacement,
    COUNT(engine_id) AS total_engines,
    SUM(CASE WHEN turbo_charged THEN 1 ELSE 0 END) AS turbo_charged_engines,
    AVG(compression_ratio) AS average_compresion_ratio
FROM
    engines
GROUP BY
    fuel_type;

-- 15 select using group by and having sentence
SELECT
    engine_type,
    AVG(horsepower) AS average_horsepower,
    COUNT(engine_id) AS total_engines
FROM
    engines
GROUP BY
    engine_type
HAVING
    AVG(horsepower) > 200;

-- 16 single line insert
INSERT INTO manufacturers (manufacturer_name, headquarters, ceo, foundation_year, revenue)
VALUES ('ElectroToyota', 'Japan', 'Akio Toyoda', 1954, 157000000);

-- 17 multi-line insert; insertion of a nested subquery
INSERT INTO sales (dealer_id, car_id, sell_date, price, warranty_period, payment_method)
SELECT
    D.dealer_id,
    C.car_id,
    CURRENT_DATE,
    25000,
    5,
    'Cash'
FROM
    cars C
JOIN
    dealersmanufacturers DM ON C.manufacturer_id = DM.manufacturer_id
JOIN
    dealers D ON DM.dealer_id = D.dealer_id
WHERE
    C.model_year = 2020 AND
    D.authorization_status = 'Authorized' AND
    D.dealer_address LIKE '%NY%';

-- 18 update
UPDATE dealers
SET authorization_status = 'Authorized'
WHERE authorization_status = 'Pending'
    AND dealer_address LIKE '%NY%';

-- 19 update instruction with a scalar subquery in a SET sentence
UPDATE engines
SET horsepower = (
    SELECT ROUND(AVG(horsepower))
    FROM engines E2
    WHERE E2.displacement = engines.displacement
)
WHERE horsepower < (
    SELECT AVG(horsepower)
    FROM engines E3
    WHERE E3.displacement = engines.displacement
);

-- 20 delete
DELETE FROm dealers
WHERE authorization_status = 'Revoked'
