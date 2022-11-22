{{
  config(
    materialized='table'
  )
}}

WITH src_sql_products AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'products') }}
    ),

renamed as (
    select
        product_id
        , CAST(price AS NUMBER(38,2)) AS price_$
        , name
        , inventory
    from src_sql_products
)

select * from renamed