WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

renamed as (

    select
        user_id
        , first_name
        , last_name
        , total_orders
        , created_at ::DATE AS created_at
        , updated_at ::DATE AS updated_at
          --Se deja este campo para ver en que fecha se registró el usuario y poder contar cuantos usuarios nuevos ha habido cada mes
        , phone_number
        , email
        , address_id

    from src_sql_users
)

select * from renamed