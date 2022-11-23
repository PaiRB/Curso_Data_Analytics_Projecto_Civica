WITH src_sql_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

renamed as  (
    select
        promo_id
        , status
        , CAST(discount AS int) AS discount
    from src_sql_promos
)

select * from renamed