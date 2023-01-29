{{ config(opt=1) }}

with source as (
    select * from {{ ref('my_table') }}
)

select * from source
