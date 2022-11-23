WITH src_sql_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

renamed_casted AS (
    SELECT
          TRIM(address_id) AS address_id
        , TRIM(zipcode) AS zipcode 
        , TRIM(country) AS country 
        , TRIM(address) AS address 
        , TRIM(state) AS state
    FROM src_sql_addresses
    )

SELECT * FROM renamed_casted
ORDER BY zipcode