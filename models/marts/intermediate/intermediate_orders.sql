{{
  config(
    materialized='table'
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
        , CAST(discount AS int) AS discount 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    )

----------------------------------------------------------------------------

--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT o.order_id
    , oit.product_id
    , o.user_id
    , o.address_id
    , o.promo_id
    , coalesce(pro.discount, 0) AS discount
    , o.status
    , p.price
    , oit.quantity
    , (p.price*oit.quantity) AS order_cost
    , CONCAT(o.order_id,'-',md5(o.shipping_cost)) AS shipping_id
    , o.shipping_cost
    , o.shipping_service
    ---------------------------------------------------
    --RESOLVER DUDA SOBRE ORDER TOTAL MANTENER O QUITAR
    , o.order_total
    ---------------------------------------------------
    , created_at 
    , created_date
    , created_time_hour
    , delivered_at
    , delivered_date
    , delivered_time_hour
    , estimated_delivery_at
    ---------------------------------------------------
    --IGUAL DUDA PARA TODOS LOS CAMPOS DE HORAS
    ---------------------------------------------------

FROM fact_order_orders o 
    JOIN fact_order_orderitems oit
    ON o.order_id = oit.order_id
    JOIN fact_order_products p
    ON oit.product_id = p.product_id
    LEFT JOIN fact_order_promos pro
    ON o.promo_id = pro.promo_id

ORDER BY o.order_id