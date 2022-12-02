{{
  config(
    materialized='ephemeral'
  )
}}

WITH fact_order_orders AS (
    SELECT
        *
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
    SELECT 
        promo_id
        , status
        , CAST(discount_USD AS int) AS discount_USD 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    )

----------------------------------------------------------------------------

--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
    -- ids
    o.order_id
    , o.natural_order_id
    , oit.product_id
    , o.user_id
    , o.address_id
    , o.promo_id
    , o.id_date_created
    , o.id_date_delivered

    -- strings
    , o.status
    , o.shipping_service

    -- numerics
    , coalesce(pro.discount_USD, 0) AS discount_USD
    , p.price_USD
    , oit.quantity
    , (p.price_USD*oit.quantity) AS order_cost_USD
    , CONCAT(o.order_id,'-',md5(o.shipping_cost_USD)) AS shipping_id
    , o.shipping_cost_USD

    -- timestamps
    , o.created_at 
    , o.created_date
    , o.delivered_at
    , (CAST(DATEDIFF(hour,o.delivered_at,o.created_at) AS int)/24) AS delivery_days
    , o.delivered_date
    , o.estimated_delivery_at
    , o.fivetran_synced

FROM fact_order_orders o 
    JOIN fact_order_orderitems oit
    ON o.order_id = oit.order_id
    JOIN fact_order_products p
    ON oit.product_id = p.product_id
    LEFT JOIN fact_order_promos pro
    ON o.promo_id = pro.promo_id

ORDER BY o.natural_order_id