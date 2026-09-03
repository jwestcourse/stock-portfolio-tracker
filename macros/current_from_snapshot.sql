{% macro current_from_snapshot(snsh_ref, output_load_ts = true) %}

SELECT * EXCLUDE (DBT_SCD_ID, DBT_UPDATED_AT, DBT_VALID_FROM, DBT_VALID_TO)

{% if output_load_ts %}
    , DBT_UPDATED_AT AS SNSH_LOAD_TS_UTC
{% endif %}

FROM {{ snsh_ref }}
WHERE DBT_VALID_TO IS NULL

{% endmacro %}