SELECT
    *
    , position_value - cost_base AS unrealized_profit_amt
    , ROUND(unrealized_profit_amt / cost_base, 5) AS unrealized_profit_pct
FROM {{ source('abc_bank', 'ABC_BANK_POSITION') }}