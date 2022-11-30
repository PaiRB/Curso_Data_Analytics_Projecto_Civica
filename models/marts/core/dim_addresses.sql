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

renamed_casted AS (
    SELECT
          address_id
        , a.zipcode AS zipcode
        , address
        , TRIM(z.primary_city) AS city
        , country 
        , state
        , fivetran_synced
    FROM stg_sql_addresses a
        JOIN zipcode_city z
        ON a.zipcode = z.zipcode
    )

SELECT * FROM renamed_casted 
ORDER BY zipcode