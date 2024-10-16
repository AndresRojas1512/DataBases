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

-- 9