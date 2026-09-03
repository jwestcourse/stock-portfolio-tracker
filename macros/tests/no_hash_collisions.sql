{% macro as_sql_list(hashed_fields_list) -%}

    {{ hashed_fields_list|join(',') }}

{%- endmacro %}


{% test no_hash_collisions(model, column_name, hashed_fields) -%}

    {{ config(severity='warn') }} --override to dbt_project.yml file and only done for single tests in each single test file

    WITH all_tuples AS (
        SELECT DISTINCT {{ column_name }} AS HASH, {{ hashed_fields }}
        FROM {{ model }}
    ),

    validation_errors AS (
        SELECT HASH, COUNT(*)
        FROM all_tuples
        GROUP BY HASH
        HAVING COUNT(*) > 1
    )

    SELECT * FROM validation_errors

{%- endtest %}