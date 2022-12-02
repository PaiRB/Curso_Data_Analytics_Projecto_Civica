{{
  config(
    materialized='view',
    unique_key='address_id'
  )
}}

WITH src_sql_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

renamed_casted AS (
    SELECT
        -- ids
        md5(address_id) AS address_id
        , TRIM(address_id) AS natural_address_id
        
        -- strings
        , TRIM(zipcode) AS zipcode
        , TRIM(address) AS address
        , TRIM(country) AS country 
        , TRIM(state) AS state

        -- timestamps
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced
        
    FROM src_sql_addresses 
    )

SELECT * FROM renamed_casted
ORDER BY zipcode