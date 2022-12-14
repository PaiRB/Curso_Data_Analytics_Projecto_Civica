{{
  config(
    materialized='incremental',
    unique_key='address_id',
    on_schema_change = 'append_new_columns'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH dim_ref_addresses AS (
    SELECT * 
    FROM {{ ref('dim_addresses') }}
    ),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
      -- ids
      address_id
      , natural_address_id
      
      -- strings
      , zipcode
      , address
      , city
      , country 
      , state

      -- timestamps
      , fivetran_synced
        
    FROM dim_ref_addresses
    )

SELECT * FROM renamed_casted 
ORDER BY zipcode


{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}