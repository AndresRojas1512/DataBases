-- 1 Comparision predicates
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

-- 2
