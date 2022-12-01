{{
  config(
    materialized='table',
    unique_key = 'product_id'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH stg_sql_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

select 
    product_id
    , natural_product_id
    , price_USD
    , provider_price_USD
    , name
    , inventory
    , fivetran_synced

from stg_sql_products