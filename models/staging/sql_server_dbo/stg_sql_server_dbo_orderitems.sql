{{
  config(
    materialized='table'
  )
}}

WITH src_sql_orderitems AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'order_items') }}
    ),

renamed as (

    select
        order_id
        , product_id
        , quantity
    from src_sql_orderitems

)

select * from renamed