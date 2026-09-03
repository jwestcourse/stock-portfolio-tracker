{{ config(materialized='ephemeral') }}

WITH
src_data AS (
    SELECT
        Name AS Name --TEXT
        , ID AS ID  --TEXT
        , Country AS Country --TEXT
        , City AS City --TEXT
        , Zone AS Zone --TEXT
        , Delta AS Delta --TEXT
        , DST_period AS DST_period --TEXT
        , Open AS Open --TEXT
        , Close AS Close --TIME
        , Lunch AS Lunch --TEXT
        , Open_UTC AS Open_UTC --TEXT
        , Close_UTC AS Close_UTC --TEXT
        , Lunch_UTC AS Lunch_UTC --TEXT
        , Load_ts AS LOAD_TS --TIMESTAMP
        , 'SEED.ABC_Bank_EXCHANGE_INFO' as RECORD_SOURCE
    FROM {{ source('seeds', 'ABC_Bank_EXCHANGE_INFO') }}
 ),

default_record AS (
    SELECT
        'Missing' AS Name
        , 'Missing' AS ID
        , 'Missing' AS Country
        , 'Missing' AS City
        , 'Missing' AS Zone
        , 'Missing' AS Delta
        , 'Missing' AS DST_period
        , 'Missing' AS Open
        , 'Missing' AS Close
        , 'Missing' AS Lunch
        , 'Missing' AS Open_UTC
        , 'Missing' AS Lunch_UTC
        , 'Missing' AS LOAD_TS
        , '2020-01-01' AS LOAD_TS_UTC
        , 'System.DefaultKey' AS RECORD_SOURCE
),

with_default_record AS (
    SELECT * FROM src_data
    UNION ALL
    SELECT * FROM default_record
),

hashed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'ID' ])
        }} AS EXCHANGE_HKEY
        , {{ dbt_utils.generate_surrogate_key([
            'ID', 'Name', 'Country', 'City', 'Zone', 'Delta', 'DST_period', 'Open', 'Close',
            'Lunch', 'Open_UTC', 'Lunch_UTC' ])
        }} AS EXCHANGE_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS AS LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed