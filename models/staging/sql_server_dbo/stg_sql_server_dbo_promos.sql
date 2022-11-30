{{
  config(
    materialized='view',
    unique_key='promo_id'
  )
}}

WITH src_sql_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

renamed as  (
    select
        -- ids
        md5 (promo_id) as promo_id

        -- strings
        , TRIM(promo_id) as desc_promo
        , TRIM(status) as status

        -- numerics
        , CAST(discount AS int) AS discount_USD

        -- timestamps
        , _fivetran_synced::timestamp_ltz AS fivetran_synced
    from src_sql_promos
)

select * from renamed