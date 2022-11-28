WITH stg_sql_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    )

select 
    product_id
    , price AS price_USD
    , CAST((price*0.40) AS NUMBER(38,2)) AS provider_price_USD
    , name
    , inventory

from stg_sql_products