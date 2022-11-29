{{
  config(
    materialized='ephemeral'
  )
}}

WITH dato_users AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

calculos_orders AS (
    SELECT
        user_id
        , COUNT(order_id) AS num_orders
    FROM {{ ref('base_sql_server_dbo_orders') }}
    GROUP BY 1
    )

SELECT
    d.user_id
    , coalesce(num_orders, 0) AS num_orders
FROM calculos_orders c
    RIGHT JOIN dato_users d
    ON c.user_id = d.user_id
  