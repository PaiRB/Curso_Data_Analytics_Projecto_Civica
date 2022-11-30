{{
  config(
    materialized='incremental',
    unique_key = 'order_id'
  )
}}

WITH fact_orders AS (
    SELECT  
        order_id
        , product_id
        , user_id
        , address_id
        , promo_id
        , shipping_id
        , status
        , order_cost_USD
        , created_at
        , created_date
        , delivered_at
        , delivered_date
        , estimated_delivery_at
        , fivetran_synced
    FROM {{ ref('intermediate_orders') }}
    )

SELECT * FROM fact_orders
ORDER BY order_id

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}