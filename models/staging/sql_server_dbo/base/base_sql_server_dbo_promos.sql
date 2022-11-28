with source as (

    select * from {{ source('src_sql_server_dbo', 'promos') }}

),

renamed as (

    select
        promo_id,
        status,
        discount,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed