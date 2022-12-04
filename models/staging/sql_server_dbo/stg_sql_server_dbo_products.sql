{{
  config(
    materialized='view',
    unique_key='product_id'
  )
}}

WITH src_sql_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

renamed as (
    select
        -- ids
        md5(TRIM(product_id)) AS product_id
        , TRIM(product_id) AS natural_product_id

        -- strings
        , TRIM(name) as name

        -- numerics
        , CAST(price AS NUMBER(38,2)) AS price_USD
        , CAST((price*0.40) AS NUMBER(38,2)) AS provider_price_USD
        , inventory

        -- timestamps
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced

    from src_sql_products
)

select * from renamed