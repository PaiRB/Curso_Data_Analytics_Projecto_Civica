{{
  config(
    materialized='table'
  )
}}

WITH src_sql_users AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'users') }}
    ),

renamed as (

    select
        user_id
        , first_name
        --, updated_at 
          --Se retira este campo ya que no va a tener uso
        , last_name
        , total_orders
        --, created_at
          --Se retira este campo ya que no va a tener uso
        , phone_number
        , email
        , address_id

    from src_sql_users
)

select * from renamed