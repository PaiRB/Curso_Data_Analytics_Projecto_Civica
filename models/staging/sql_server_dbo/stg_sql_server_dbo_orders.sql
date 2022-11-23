WITH src_sql_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    SELECT
          order_id
        , user_id
        , address_id
        , promo_id
        , status
        , order_total
        , order_cost
        , shipping_cost
        , shipping_service
        , created_at ::DATE AS order_date
        , created_at ::TIME AS order_time_hour
        , delivered_at
        , estimated_delivery_at ::DATE AS estimated_delivery_at
        
    FROM src_sql_orders
    )

SELECT * FROM renamed_casted