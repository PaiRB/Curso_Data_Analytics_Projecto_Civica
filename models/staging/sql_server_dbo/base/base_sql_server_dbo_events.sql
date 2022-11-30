{{
  config(
    materialized='view'
  )
}}

with source as (

    select * from {{ source('src_sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id
        , user_id
        , session_id
        , product_id
        , created_at
        , event_type
        , order_id
        , page_url
        , _fivetran_deleted
        , _fivetran_synced

    from source

)

select * from renamed