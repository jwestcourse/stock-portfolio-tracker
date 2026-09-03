{{ config(materialized='ephemeral')}}

WITH src_data As (
    SELECT
        ACCOUNTID AS ACCOUNT_CODE -- TEXT
        , SYMBOL AS SECURITY_CODE -- TEXT
        , DESCRIPTION AS SECURITY_NAME -- TEXT
        , EXCHANGE AS EXCHANGE_CODE -- TEXT
        , {{ convert_year('REPORT_DATE') }} AS REPORT_DATE -- DATE
        , QUANTITY AS QUANTITY -- NUMBER
        , COST_BASE AS COST_BASE -- NUMBER
        , POSITION_VALUE AS POSITION_VALUE -- NUMBER
        , CURRENCY AS CURRENCY_CODE -- TEXT
        , 'SOURCE_DATA.ABC_BANK_POSITION' AS RECORD_SOURCE
    FROM {{ source('abc_bank', 'ABC_BANK_POSITION') }}
),

default_record AS (
    SELECT
        'Missing' AS ACCOUNT_CODE --TEXT
        , 'Missing' AS SECURITY_CODE --TEXT
        , 'Missing' AS SECURITY_NAME --TEXT
        , 'Missing' AS EXCHANGE_CODE --TEXT
        , '2020-01-01' AS REPORT_DATE
        , -1 AS QUANTITY --NUMBER(5,0)
        , -1 AS COST_BASE --NUMBER(5,0)
        , -1 AS POSITION_VALUE --NUMBER(5,0)
        , 'Missing' AS CURRENCY_CODE --TEXT
        , 'System.DefaultKey' AS RECORD_SOURCE
),

with_default_record AS (
    SELECT * FROM src_data
    UNION ALL
    SELECT * FROM default_record
),

hashed as (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'ACCOUNT_CODE', 'SECURITY_CODE'])
        }} AS POSITION_HKEY
        , {{ dbt_utils.generate_surrogate_key([
            'ACCOUNT_CODE', 'SECURITY_CODE', 'SECURITY_NAME'
            , 'EXCHANGE_CODE', 'REPORT_DATE', 'QUANTITY', 'COST_BASE'
            , 'POSITION_VALUE', 'CURRENCY_CODE'])
        }} AS POSITION_HDIFF
        , *
        , '{{ run_started_at }}' as LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed
