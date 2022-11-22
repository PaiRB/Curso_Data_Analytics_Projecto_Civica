{{
  config(
    materialized='table'
  )
}}

WITH src_sql_orderitems AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orderitems') }}
    ),

renamed as (

    select
        order_id
        , product_id
        , quantity
    from src_sql_orderitems

)

select * from renamed