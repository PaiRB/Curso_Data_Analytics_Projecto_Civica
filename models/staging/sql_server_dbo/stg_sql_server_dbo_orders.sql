{{
  config(
    materialized='table'
  )
}}

WITH src_sql_orders AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
          order_id
        , user_id
        , promo_id
        , status AS Estado_del_pedido
        , order_total AS Coste_total_$
        , order_cost AS Coste_pedido_$
        , shipping_cost AS Coste_envio_$
        , shipping_service AS Servicio_envio
        , delivered_at AS Fecha_recepcion
        , estimated_delivery_at AS Fecha_estimada_recepcion
        , created_at AS Fecha_pedido
        , address_id
    FROM src_sql_orders
    )

SELECT * FROM renamed_casted