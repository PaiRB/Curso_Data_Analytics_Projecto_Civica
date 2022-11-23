WITH src_sql_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

renamed as (
    select
        product_id
        , CAST(price AS NUMBER(38,2)) AS price
        , name
        , inventory
    from src_sql_products
)

select * from renamed