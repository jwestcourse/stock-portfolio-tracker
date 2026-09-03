{{ config(materialized='ephemeral') }}

WITH
src_data AS (
    SELECT
        AlphabeticCode AS AlphabeticCode--TEXT
        , NumericCode AS NumericCode --NUMBER(5,0)
        , DecimalDigits AS DecimalDigits --NUMBER(5,0)
        , CurrencyName AS CurrencyName --TEXT
        , Locations AS Locations --TEXT
        , load_ts AS LOAD_TS --TIMESTAMP
         , 'SEED.ABC_Bank_CURRENCY_INFO' as RECORD_SOURCE
    FROM {{ source('seeds', 'ABC_Bank_CURRENCY_INFO') }}
 ),

default_record AS (
    SELECT
        'Missing' AS AlphabeticCode --TEXT
        , -1 AS NumericCode --NUMBER(5,0)
        , -1 AS DecimalDigits --NUMBER(5,0)
        , 'Missing' AS CurrencyName --TEXT
        , 'Missing' AS Locations --TEXT
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
            'AlphabeticCode' ])
        }} AS CURRENCY_HKEY
        , {{ dbt_utils.generate_surrogate_key([
            'AlphabeticCode', 'NumericCode', 'DecimalDigits',
            'CurrencyName', 'Locations' ])
        }} AS CURRENCY_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS AS LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed