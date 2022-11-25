WITH src_sql_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

renamed as  (
    select
        md5 (promo_id) as promo_id
        , TRIM(promo_id) as desc_promo
        , TRIM(status) as status
        , CAST(discount AS int) AS discount
    from src_sql_promos
)

select * from renamed