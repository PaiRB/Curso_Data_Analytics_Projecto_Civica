{{
  config(
    materialized='table'
  )
}}

WITH shipping AS (
    SELECT  
        shipping_id
        , shipping_service
        , shipping_cost
    FROM {{ ref('intermediate_orders') }}
    )

SELECT  
    DISTINCT(shipping_id)
    , CASE
        WHEN shipping_service = '' THEN 'Pendiente'
        ELSE shipping_service
        END AS shipping_service
    , shipping_cost
FROM shipping