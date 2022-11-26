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
        , SUM(order_cost) AS order_cost
        , shipping_cost
        , discount
        , order_total
        , shipping_service
    FROM {{ ref('intermediate_orders') }}
    GROUP BY order_id, shipping_cost, discount, order_total, shipping_service
    )
/*
--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
    order_id
    , order_cost
    , shipping_cost
    , discount
    , ((order_cost+shipping_cost)-discount) AS total_order
FROM prueba_orders
GROUP BY order_id, order_cost, shipping_cost, discount
*/


--ESTA CONSULTA FUNCIONA Y DA EL RESULTADO CORRECTO, NO BORRAR
SELECT 
    DISTINCT order_id
    , order_total
FROM prueba_orders