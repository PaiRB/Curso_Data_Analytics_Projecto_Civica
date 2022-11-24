WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

renamed as (

    select
        TRIM(user_id) AS user_id
        , TRIM(first_name) AS first_name
        , TRIM(last_name) AS last_name
        , total_orders
        , TRIM(phone_number) AS phone_number
        , TRIM(email) AS email
        , TRIM(address_id) AS address_id
        --Se deja este campo para ver en que fecha se registró el usuario y poder contar cuantos usuarios nuevos ha habido cada mes
        , created_at
        , created_at ::DATE AS created_date
        , created_at ::TIME AS created_time_hour
        , updated_at
        , updated_at ::DATE AS updated_date
        , updated_at ::TIME AS updated_time_hour

    from src_sql_users
)

select * from renamed