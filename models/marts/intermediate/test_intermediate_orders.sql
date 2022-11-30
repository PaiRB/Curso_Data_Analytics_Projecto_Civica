--ESTA CONSULTA ES PARA COMPROBAR SI SE PUEDE OBTENER EL ORDER_TOTAL ORIGINAL A PARTIR
--DE LOS VALORES CALCULADOS EN LAS NUEVAS MÉTRICAS -> SPOILER: SI SE PUEDE
--QUEDA POR SOLVENTAR QUE ES MEJOR

{{
  config(
    materialized='ephemeral'
  )
}}

WITH prueba_orders AS (
    SELECT 
        order_id
        , SUM(order_cost_USD) AS order_cost_USD
        , shipping_cost_USD
        , discount_USD
        , shipping_service
    FROM {{ ref('intermediate_orders') }}
    GROUP BY order_id, shipping_cost_USD, discount_USD, shipping_service
    )

--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
    order_id
    , order_cost_USD
    , shipping_cost_USD
    , discount_USD
    , ((order_cost_USD+shipping_cost_USD)-discount_USD) AS total_order_USD
FROM prueba_orders
GROUP BY order_id, order_cost_USD, shipping_cost_USD, discount_USD


/*
--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
    DISTINCT order_id
    , order_total
FROM prueba_orders
*/