{{
  config(
    materialized='table'
  )
}}

WITH fact_order_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),

fact_order_orderitems AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orderitems') }}
    ),

fact_order_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

fact_order_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    ),

orders as (
    select
          order_id
        , user_id
        , address_id
        , promo_id
        , order_cost_$
        , order_total_$
        , status
        , shipping_cost_$
        , shipping_service 
        , order_date
        , order_time_hour
        , delivered_at
        , estimated_delivery_at
    from fact_order_orders
),

----------------------------------------------------------------------------

orderitems as (
    select
        order_id
        , product_id
        , quantity
    from fact_order_orderitems
),

----------------------------------------------------------------------------

products as (
    select
        product_id
        , price_$
        , name
        , inventory
    from fact_order_products
),

----------------------------------------------------------------------------


promos as  (
    select
        promo_id
        , status
        , CAST(discount AS int) AS discount
    from fact_order_promos
)

----------------------------------------------------------------------------

SELECT o.order_id
    , oit.product_id
    , o.user_id
    , o.promo_id
    --, o.address_id
    --, pro.discount
    --, o.status
    , p.price_$
    , oit.quantity
    , (p.price_$*oit.quantity) AS precio_$
    , o.order_cost_$
    , o.shipping_cost_$
    , o.order_total_$

FROM orders o 
    JOIN orderitems oit
    ON o.order_id = oit.order_id
    JOIN products p
    ON oit.product_id = p.product_id
    --JOIN promos pro
    --ON o.promo_id = pro.promo_id

ORDER BY o.order_id