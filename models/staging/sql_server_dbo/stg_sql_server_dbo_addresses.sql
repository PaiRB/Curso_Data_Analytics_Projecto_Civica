WITH src_sql_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id
        , zipcode 
        , country 
        , address 
        , state
    FROM src_sql_addresses
    )

SELECT * FROM renamed_casted