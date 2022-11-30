{{
  config(
    materialized='incremental',
    unique_key = 'shipping_id'
  )
}}

WITH shipping AS (
    SELECT  
        shipping_id
        , shipping_service
        , shipping_cost_USD
        , fivetran_synced
    FROM {{ ref('intermediate_orders') }}
    )

SELECT  
    DISTINCT(shipping_id)
    , CASE
        WHEN shipping_service = '' THEN 'Pendiente'
        ELSE shipping_service
        END AS shipping_service
    , shipping_cost_USD
    , fivetran_synced
FROM shipping

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}