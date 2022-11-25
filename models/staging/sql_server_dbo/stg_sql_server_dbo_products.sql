WITH src_sql_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

renamed as (
    select
        TRIM(product_id) AS product_id
        , CAST(price AS NUMBER(38,2)) AS price
        , TRIM(name) as name
        , inventory
    from src_sql_products
)

select * from renamed