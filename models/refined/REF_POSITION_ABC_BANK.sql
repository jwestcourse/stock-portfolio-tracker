WITH current_from_snapshot AS (
    SELECT
        *
    FROM {{ ref('SNSH_ABC_BANK_POSITION') }}
    WHERE DBT_VALID_TO IS NULL
)
SELECT
    *
    , position_value - cost_base AS unrealized_profit_amt
    , ROUND(unrealized_profit_amt / cost_base, 5) AS unrealized_profit_pct
FROM current_from_snapshot