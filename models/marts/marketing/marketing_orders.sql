--ESTA CONSULTA ES PARA COMPROBAR SI SE PUEDE OBTENER EL ORDER_TOTAL ORIGINAL A PARTIR
--DE LOS VALORES CALCULADOS EN LAS NUEVAS MÉTRICAS -> SPOILER: SI SE PUEDE
--QUEDA POR SOLVENTAR QUE ES MEJOR

{{
  config(
    materialized='view'
  )
}}

WITH prueba_orders AS (
    SELECT
        natural_order_id
        , SUM(order_cost_USD) AS order_cost_USD
        , promo_id
        , shipping_id

    FROM {{ ref('fact_orders') }}
      
    GROUP BY 
      natural_order_id 
      , promo_id
      , shipping_id
    ),

prueba_shipping AS (
    SELECT 
        shipping_id
        , shipping_cost_USD
        , shipping_service
    FROM {{ref('dim_shipping') }}
    ),


prueba_promos AS (
    SELECT 
        promo_id
        , coalesce(discount_USD,0) AS discount_USD
    FROM {{ref('dim_promos') }}
    )

--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT
    natural_order_id
    , order_cost_USD
    , s.shipping_cost_USD
    , coalesce(p.discount_USD,0) AS discount_USD
    , ROUND(((order_cost_USD+shipping_cost_USD)-coalesce(p.discount_USD,0)),2) AS total_order_USD

FROM prueba_orders o 
  FULL JOIN prueba_promos p
  ON o.promo_id = p.promo_id
  FULL JOIN prueba_shipping s
  ON o.shipping_id = s.shipping_id

GROUP BY
  natural_order_id
  , order_cost_USD
  , s.shipping_cost_USD
  , p.discount_USD


/*
--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
  SUM(order_cost_USD)
FROM prueba_orders
*/