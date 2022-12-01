{{
  config(
    materialized='incremental',
    unique_key = 'fact_order_id'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH fact_orders AS (
    SELECT
        *
    FROM {{ ref('intermediate_orders') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

SELECT
    -- ids
    md5(CONCAT(order_id,product_id)) AS fact_order_id  
    , order_id
    , natural_order_id
    , product_id
    , user_id
    , address_id
    , promo_id
    , shipping_id
    , id_date_created
    , id_date_delivered

    -- strings
    , status

    -- numerics
    , order_cost_USD

    -- timestamps
    , created_at
    , created_date
    , delivered_at
    , delivered_date
    , estimated_delivery_at
    , fivetran_synced

FROM fact_orders
ORDER BY natural_order_id

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}