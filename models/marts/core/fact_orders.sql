{{
  config(
    materialized='table'
  )
}}

WITH fact_orders AS (
    SELECT  
        order_id
        , product_id
        , user_id
        , address_id
        , promo_id
        , shipping_id
        , status
        , order_cost
        , created_at
        , delivered_at
        , estimated_delivery_at
    FROM {{ ref('intermediate_orders') }}
    )

SELECT * FROM fact_orders