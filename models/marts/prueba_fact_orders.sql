{{
  config(
    materialized='ephemeral'
  )
}}

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
    , price
    , quantity
    , order_cost
    , shipping_cost
    , order_total
    FROM test_fact_orders
)

/*
select DISTINCT(user_id)
    from prueba
*/

select user_id
    , ROUND((SUM(order_cost)+shipping_cost),2) AS Total
    from prueba

group by user_id, shipping_cost
order by Total DESC