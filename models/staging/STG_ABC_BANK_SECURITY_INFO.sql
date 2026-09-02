{{ config(materialized='ephemeral') }}

WITH
src_data AS (
    SELECT
        SECURITY_CODE AS SECURITY_CODE -- TEXT
         , SECURITY_NAME AS SECURITY_NAME -- TEXT
         , SECTOR AS SECTOR_NAME -- TEXT
         , INDUSTRY AS INDUSTRY_NAME -- TEXT
         , COUNTRY AS COUNTRY_CODE -- TEXT
         , EXCHANGE AS EXCHANGE_CODE -- TEXT
         , LOAD_TS AS LOAD_TS -- TIMESTAMP_NTZ
         , 'SEED.ABC_Bank_SECURITY_INFO' as RECORD_SOURCE
    FROM {{ source('seeds', 'ABC_Bank_SECURITY_INFO') }}
 ),

default_record AS (
    SELECT
        '-1' AS SECURITY_CODE
        , 'Missing' AS SECURITY_NAME
        , 'Missing' AS SECTOR_NAME
        , 'Missing' AS INDUSTRY_NAME
        , '-1' AS COUNTRY_CODE
        , '-1' AS EXCHANGE_CODE
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
        concat_ws('|', SECURITY_CODE) AS SECURITY_HKEY
        , concat_ws('|', SECURITY_CODE, SECURITY_NAME, SECTOR_NAME,
                         INDUSTRY_NAME, COUNTRY_CODE, EXCHANGE_CODE ) AS SECURITY_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS AS LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed