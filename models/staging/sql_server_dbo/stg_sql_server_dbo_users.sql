WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

renamed as (

    select
        TRIM(u.user_id) AS u.user_id
        , TRIM(first_name) AS first_name 
        , TRIM(last_name) AS last_name
        --, s.age
        --, s.sex
        , total_orders
        , TRIM(phone_number) AS phone_number
        , TRIM(email) AS email
        , TRIM(address_id) AS address_id
        --Se deja este campo para ver en que fecha se registró el usuario y poder contar cuantos usuarios nuevos ha habido cada mes
        , created_at
        , created_at ::DATE AS created_date
        , updated_at
        , updated_at ::DATE AS updated_date

    from src_sql_users u 
        --join seed_age_sex_users s
        --on u.user_id = s.user_id
)

select * from renamed