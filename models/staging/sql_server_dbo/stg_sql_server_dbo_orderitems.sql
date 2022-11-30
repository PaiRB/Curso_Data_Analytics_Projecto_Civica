{{
  config(
    materialized='view',
    unique_key='orderitem_id'
  )
}}

WITH src_sql_orderitems AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orderitems') }}
    ),

renamed as (

    select
        -- ids
        md5(CONCAT(order_id,'-',product_id)) AS orderitem_id
        , md5(TRIM(order_id)) AS order_id
        , md5(TRIM(product_id)) AS product_id

        -- numerics
        , quantity

        -- timestamps
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced

    from src_sql_orderitems

)

select * from renamed