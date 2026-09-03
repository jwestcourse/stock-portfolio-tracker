WITH current_from_snapshot AS (
    {{
        current_from_snapshot(
            snsh_ref = ref('SNSH_ABC_BANK_POSITION'),
            output_load_ts = false,
        )
    }}
)
SELECT
    *
    , position_value - cost_base AS unrealized_profit_amt
    , ROUND(unrealized_profit_amt / cost_base, 5) * 100 AS unrealized_profit_pct
FROM current_from_snapshot