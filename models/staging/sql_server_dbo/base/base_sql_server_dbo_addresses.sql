{{
  config(
    materialized='view'
  )
}}

with source as (

    select * from {{ source('src_sql_server_dbo', 'addresses') }}

),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
WHERE _fivetran_deleted = FALSE