with payments as (
select *
from {{ ref('stg_stripe__payments') }}
),

select 
sum(case when payment_status = 'success' then payment_amount end) as payment_amount
from payments p


