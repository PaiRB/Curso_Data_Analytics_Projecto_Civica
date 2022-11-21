{{
  config(
    materialized='table'
  )
}}

WITH src_sql_promos AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'promos') }}
    ),

renamed as  (
    select
        promo_id
        , status
        , CAST(discount AS int) AS discount
    from src_sql_promos
)

select * from renamed