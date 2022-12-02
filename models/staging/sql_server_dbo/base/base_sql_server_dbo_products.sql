{{
  config(
    materialized='view'
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
WHERE _fivetran_deleted = FALSE