{{
  config(
    materialized='table'
  )
}}

with source as (

    select * from {{ source('src_sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed