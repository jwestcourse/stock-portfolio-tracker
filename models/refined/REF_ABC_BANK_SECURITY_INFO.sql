WITH current_from_history AS (
    {{
        current_from_history(
            history_rel = ref('HIST_ABC_BANK_SECURITY_INFO'),
            key_column = 'SECURITY_HKEY',
        )
    }}
)
SELECT
    *
FROM current_from_history