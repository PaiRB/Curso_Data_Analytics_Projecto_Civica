WITH test_fact_orders AS (
    SELECT * 
    FROM {{ ref('fact_orders') }}
    ),

prueba as (
    SELECT order_id
    , product_id
    , user_id
    , address_id
    , promo_id
    , discount
    , status
    , price_$
    , quantity
    , order_cost_$
    , shipping_cost_$
    , order_total_$
    FROM test_fact_orders
)

select user_id
    , (SUM(order_cost_$)+shipping_cost_$) AS Total
    from prueba

group by user_id, shipping_cost_$
order by Total DESC