WITH src_sql_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    SELECT
          TRIM(order_id) AS order_id
        , TRIM(user_id) AS user_id
        , TRIM(address_id) AS address_id
        , CASE 
            WHEN promo_id = '' THEN ''
            ELSE md5 (promo_id)
            END AS promo_id
        , TRIM(status) AS status
        , order_total
        , order_cost
        , shipping_cost
        , TRIM(shipping_service) AS shipping_service
        , created_at
        , created_at ::DATE AS created_date
        , delivered_at
        , delivered_at ::DATE AS delivered_date
        , estimated_delivery_at ::DATE AS estimated_delivery_at
        
    FROM src_sql_orders
    )

SELECT * FROM renamed_casted