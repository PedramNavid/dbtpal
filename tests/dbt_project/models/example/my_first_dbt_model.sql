
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

with source_data as (

    select 1 as id
    union all
    select 2 as id
    union all
    select 3 from {{ ref('my table')}}
    union all
    select 4 from {{source('my_schema', 'my_table')}}

)

{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

{# This is a comment in dbt templating syntax #}
select
    order_id,

    {% for payment_method in payment_methods %}

    sum(case when payment_method = '{{payment_method}}' then amount end)
        as {{payment_method}}_amount,

    {% endfor %}

    sum(amount) as total_amount
from app_data.payments
group by 1

select *
from source_data
join {{ ref('test') }}

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
