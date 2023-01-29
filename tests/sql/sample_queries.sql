{% macro email_to_domain(column_name) %}
    '@' || trim(lower(regexp_substr({{ column_name }}, '@(.+)', 1, 1, 'e', 1)))
{% endmacro %}

{% set sessionization_cutoff %}
(
    select
        {{ dbt_utils.dateadd(
            'hour',
            -3,
            'max(session_start_tstamp)'
        ) }}
    from {{this}}
)
{% endset %}

with tbl as (
    select * from {{ ref('my table') }}
),

/* TODO: Fix me */

{% set partition_by = "partition by session_id" %}
foo as (

    select

        {% for (key, value) in first_values.items() %}
        first_value({{key}}) over ({{window_clause}}) as {{value}},
        {% endfor %}

    from {{ source('other', 'table') }}
)

{% if is_incremental() %}

select * from big_table

{% endif %}



