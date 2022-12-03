{{
  config(
    materialized='incremental',
    unique_key='address_id'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH stg_sql_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_addresses') }}
    ),

zipcode_city AS (
    SELECT 
        CAST(zip AS VARCHAR) AS zipcode
        , primary_city
    FROM {{ref('zipcode_cities')}}
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
      , a.zipcode AS zipcode
      , address
      , TRIM(z.primary_city) AS city
      , country 
      , state

      -- timestamps
      , fivetran_synced
        
    FROM stg_sql_addresses a
        JOIN zipcode_city z
        ON a.zipcode = z.zipcode
    )

SELECT * FROM renamed_casted 
ORDER BY zipcode


{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}
