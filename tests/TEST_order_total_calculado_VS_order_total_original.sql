WITH orders AS (
    SELECT * 
    FROM {{ ref('marketing_orders') }}
    ),

stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    )

SELECT
    -- ids
    o.natural_order_id

    -- numerics
    , o.total_order_USD
    , stgo.order_total_USD

FROM orders o 
  FULL JOIN  stg_orders stgo
  ON o.natural_order_id = stgo.natural_order_id
WHERE o.total_order_USD <> stgo.order_total_USD