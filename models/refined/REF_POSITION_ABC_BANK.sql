WITH current_from_history AS (
    {{
        current_from_history(
            history_rel = ref('HIST_ABC_BANK_POSITION'),
            key_column = 'POSITION_HKEY',
        )
    }}
)
SELECT
    *
    , position_value - cost_base AS unrealized_profit_amt
    , ROUND(unrealized_profit_amt / cost_base, 5) * 100 AS unrealized_profit_pct
FROM current_from_history