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
        , address_id
        , promo_id
        , status
        , order_total AS order_total_$
        , order_cost AS order_cost_$
        , shipping_cost AS shipping_cost_$
        , shipping_service 

        , created_at ::DATE AS order_date
        , created_at ::TIME AS order_time_hour
        , delivered_at
        , estimated_delivery_at ::DATE AS estimated_delivery_at
        
    FROM src_sql_orders
    )

SELECT * FROM renamed_casted