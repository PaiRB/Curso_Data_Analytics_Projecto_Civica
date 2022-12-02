{{
  config(
    materialized='view'
  )
}}

with source as (

    select * from {{ source('src_sql_server_dbo', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
WHERE _fivetran_deleted = FALSE