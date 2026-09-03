WITH test_data AS (
    SELECT '0021-09-23'::date as src_date,
            '2021-09-23'::date as expected_date

        UNION

    SELECT '1021-09-24', '1021-09-24'

        UNION

    SELECT '2021-09-25', '2021-09-25'

        UNION

    SELECT '-0021-09-26', '1979-09-26' -- i guess 1979-09-26 is the default 'beginning of time'

        UNION

    SELECT '-0021-09-26', '2021-09-26' --this row should error because the year won't be updated
)

SELECT
    {{convert_year('src_date')}} as ok_date,
    expected_date,
    ok_date = expected_date as matching
FROM test_data
WHERE NOT MATCHING