{{
  config(
    materialized='table'
  )
}}

with source as (

    select * from {{ source('src_sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        first_name,
        updated_at,
        last_name,
        total_orders,
        created_at,
        phone_number,
        email,
        address_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed