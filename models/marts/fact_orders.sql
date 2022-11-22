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
    , o.address_id
    , o.promo_id
    , coalesce(pro.discount, 0) AS discount --sirve para lo mismo que poner un case when para quitar los nulos y sustituirlos por ceros.
    , o.status
    , p.price_$
    , oit.quantity
    , (p.price_$*oit.quantity) AS order_cost_$
    , o.shipping_cost_$
    /*
    , CASE
        WHEN pro.discount IS NULL THEN ((p.price_$*oit.quantity)+o.shipping_cost_$)
        ELSE (((p.price_$*oit.quantity)+o.shipping_cost_$)-pro.discount)
        END AS total_cost_$
    */
    , o.order_total_$

FROM orders o 
    JOIN orderitems oit
    ON o.order_id = oit.order_id
    JOIN products p
    ON oit.product_id = p.product_id
    LEFT JOIN promos pro
    ON o.promo_id = pro.promo_id

ORDER BY o.order_id