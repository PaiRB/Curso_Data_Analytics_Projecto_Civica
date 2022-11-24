WITH src_sql_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

zipcode_city AS (
    SELECT 
        CAST(zip AS VARCHAR) AS zipcode
        , primary_city
    FROM {{ref('zipcode_cities')}}
),

renamed_casted AS (
    SELECT
          TRIM(address_id) AS address_id
        , TRIM(a.zipcode) AS zipcode
        , TRIM(address) AS address
        , TRIM(z.primary_city) AS city
        , TRIM(country) AS country 
        , TRIM(state) AS state
    FROM src_sql_addresses a
        JOIN zipcode_city z
        ON a.zipcode = z.zipcode
    )

SELECT * FROM renamed_casted 
ORDER BY zipcode