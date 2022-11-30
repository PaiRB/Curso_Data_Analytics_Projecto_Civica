{{
  config(
    materialized='view',
    unique_key='order_id'
  )
}}

WITH src_sql_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    SELECT
        -- ids
        md5 (order_id) AS order_id
        , TRIM(order_id) AS natural_order_id
        , md5(TRIM(user_id)) AS user_id
        , md5(TRIM(address_id)) AS address_id
        , CASE 
            WHEN promo_id = '' THEN ''
            ELSE md5 (promo_id)
            END AS promo_id
        
        -- strings
        , TRIM(status) AS status
        , TRIM(shipping_service) AS shipping_service

        -- numerics
        , order_total AS order_total_USD
        , order_cost AS order_cost_USD
        , shipping_cost AS shipping_cost_USD

        -- timestamps
        , created_at ::timestamp_ltz AS created_at
        , created_at ::DATE AS created_date 
        , delivered_at ::timestamp_ltz AS delivered_at
        , delivered_at ::DATE AS delivered_date
        , estimated_delivery_at ::DATE AS estimated_delivery_at
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced
        
    FROM src_sql_orders
    )

SELECT * FROM renamed_casted