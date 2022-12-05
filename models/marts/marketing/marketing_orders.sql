--ESTA CONSULTA ES PARA COMPROBAR SI SE PUEDE OBTENER EL ORDER_TOTAL ORIGINAL A PARTIR
--DE LOS VALORES CALCULADOS EN LAS NUEVAS MÉTRICAS -> SI SE PUEDE

{{
  config(
    materialized='view'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH prueba_orders AS (
    SELECT
        natural_order_id
        , SUM(order_cost_USD) AS order_cost_USD
        , user_id
        , promo_id
        , shipping_id
        ----
        , status
        ----
        , shipping_cost_USD
        , shipping_service
        , delivery_days
        ----

    FROM {{ ref('fact_orders') }}
      
    GROUP BY 
      natural_order_id 
      , promo_id
      , shipping_id
      , user_id
      , shipping_cost_USD
      , shipping_service
      , delivery_days
      , status
    ),


prueba_orders_dos AS (
    SELECT
        order_id
        , natural_order_id
        
    FROM {{ ref('fact_orders') }}
    ),


prueba_users AS (
    SELECT 
        user_id
        , client_full_name
        , first_name
        , last_name
        , phone_number
        , email
    FROM {{ref('dim_users') }}
    ),

prueba_promos AS (
    SELECT 
        promo_id
        , coalesce(discount_USD,0) AS discount_USD
    FROM {{ref('dim_promos') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

SELECT
    -- ids
    dos.order_id
    , o.natural_order_id

    -- strings
    , client_full_name
    , phone_number
    , email

    -- numerics
    , order_cost_USD
    , o.shipping_cost_USD
    , coalesce(p.discount_USD,0) AS discount_USD
    , ROUND(((order_cost_USD+o.shipping_cost_USD)-coalesce(p.discount_USD,0)),2) AS total_order_USD
    , status
    , delivery_days

FROM prueba_orders o 
  FULL JOIN prueba_promos p
  ON o.promo_id = p.promo_id
  LEFT JOIN prueba_users u
  ON o.user_id = u.user_id
  LEFT JOIN prueba_orders_dos dos
  ON o.natural_order_id = dos.natural_order_id
  
{{ dbt_utils.group_by(11)}}
ORDER BY client_full_name ASC


/*
--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
  SUM(order_cost_USD)
FROM prueba_orders
*/