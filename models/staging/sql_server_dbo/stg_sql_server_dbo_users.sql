WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

age_sex AS (
    SELECT
        user_id 
        , CAST(age AS NUMBER(38,0)) AS age  
        , sex
    FROM {{ref('age_sex_of_users')}}
),

renamed as (

    select
        TRIM(u.user_id) AS user_id
        , TRIM(first_name) AS first_name 
        , TRIM(last_name) AS last_name
        , age
        , sex
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
        join age_sex s
        on u.user_id = s.user_id
)

select * from renamed