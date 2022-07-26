{%- set payments = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] -%} 

with payments as (
    select * from {{ ref('stg_payments') }}
)

select 
    order_id,

    {% for payment in payments -%}
        sum(CASE WHEN payment_method = '{{payment}}' THEN amount ELSE 0 END) AS {{ payment }}_amount

    {% if not loop.last %},
    {%- endif -%}
    
    {%- endfor -%}


FROM payments
WHERE status = 'success';
GROUP BY order_id;
