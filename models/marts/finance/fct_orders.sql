{{
    config(
        materialized='incremental',
        incremental_strategy = 'microbatch',
        event_time = 'order_date',
        begin ='2018-01-01',
        batch_size = 'day',
        lookback = 2,
        full_refresh = false
    )
}}
with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),
orders as(
    select * from {{ ref('stg_jaffle_shop__orders') }}
),
order_payments as(
    select order_id,
    sum(case when payment_status = 'success' then payment_amount end) as amount
    from payments 
    group by 1
),
final as (
    select orders.order_id,
    orders.customer_id,
    orders.order_date,
    order_payments.amount
    from orders 
    left join order_payments using(order_id)
)
select * from final
order by order_date desc