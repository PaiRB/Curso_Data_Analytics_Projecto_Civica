{{
  config(
    materialized='ephemeral'
  )
}}

WITH calculo_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

    calculo_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),

users AS (
    SELECT
        user_id
    FROM calculo_users
),

orders AS (
    SELECT 
        order_id,
        user_id
    FROM calculo_orders
)

SELECT DISTINCT(u.user_id)
    , COUNT(o.order_id) AS num_orders
FROM orders o 
    JOIN users u
    ON o.user_id = u.user_id
GROUP BY u.user_id