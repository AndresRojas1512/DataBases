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

-- 3