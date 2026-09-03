{{ config(materialized='ephemeral') }}

WITH
src_data AS (
    SELECT
        country_name AS country_name --TEXT
        , country_code_2_letter AS country_code_2_letter --TEXT
        , country_code_3_letter AS country_code_3_letter --TEXT
        , country_code_numeric AS country_code_numeric --NUMBER(5,0)
        , iso_3166_2 AS iso_3166_2 --TEXT
        , region AS region --TEXT
        , sub_region AS sub_region --TEXT
        , intermediate_region AS intermediate_region --TEXT
        , region_code AS region_code --NUMBER(5,0)
        , sub_region_code AS sub_region_code --NUMBER(5,0)
        , intermediate_region_code AS intermediate_region_code --NUMBER(5,0)
        , load_ts AS LOAD_TS --TIMESTAMP
         , 'SEED.ABC_Bank_COUNTRY_INFO' as RECORD_SOURCE
    FROM {{ source('seeds', 'ABC_Bank_COUNTRY_INFO') }}
 ),

default_record AS (
    SELECT
        'Missing' AS country_name --TEXT
        , 'Missing' AS country_code_2_letter --TEXT
        , 'Missing' AS country_code_3_letter --TEXT
        , -1 AS country_code_numeric --NUMBER(5,0)
        , 'Missing' AS iso_3166_2 --TEXT
        , 'Missing' AS region --TEXT
        , 'Missing' AS sub_region --TEXT
        , 'Missing' AS intermediate_region --TEXT
        , -1 AS region_code --NUMBER(5,0)
        , -1 AS sub_region_code --NUMBER(5,0)
        , -1 AS intermediate_region_code --NUMBER(5,0)
        , '2020-01-01' AS LOAD_TS_UTC
        , 'Missing' AS RECORD_SOURCE
),

with_default_record AS (
    SELECT * FROM src_data
    UNION ALL
    SELECT * FROM default_record
),

hashed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'country_code_2_letter' ])
        }} AS COUNTRY_HKEY
        , {{ dbt_utils.generate_surrogate_key([
            'country_code_2_letter', 'country_name', 'country_code_3_letter', 'country_code_numeric',
            'iso_3166_2', 'region', 'sub_region', 'intermediate_region', 
            'region_code', 'sub_region_code', 'intermediate_region_code' ])
        }} AS COUNTRY_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS AS LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed