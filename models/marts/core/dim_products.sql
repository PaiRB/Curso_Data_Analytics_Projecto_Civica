WITH stg_sql_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    )

select 
    product_id
    , price_USD
    , provider_price_USD
    , name
    , inventory
    , fivetran_synced

from stg_sql_products