{{
  config(
    materialized='incremental',
    unique_key = 'product_id',
    on_schema_change = 'append_new_columns'
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


{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}