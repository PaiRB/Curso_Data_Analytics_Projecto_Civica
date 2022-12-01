{{
  config(
    materialized='view',
    unique_key='user_id'
  )
}}

WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

renamed as (

    select
        -- ids
        md5(u.user_id) AS user_id
        , TRIM(u.user_id) AS natural_user_id
        , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date_created
        , year(updated_at)*10000+month(updated_at)*100+day(updated_at) as id_date_updated

        -- strings
        , TRIM(first_name) AS first_name 
        , TRIM(last_name) AS last_name
        , TRIM(phone_number) AS phone_number
        , TRIM(email) AS email
        , TRIM(address_id) AS address_id

        -- numerics
        , total_orders

        -- timestamps
        , created_at ::timestamp_ltz AS created_at
        , created_at ::DATE AS created_date
        , updated_at ::timestamp_ltz AS updated_at
        , updated_at ::DATE AS updated_date
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced

    from src_sql_users u 

)

select * from renamed