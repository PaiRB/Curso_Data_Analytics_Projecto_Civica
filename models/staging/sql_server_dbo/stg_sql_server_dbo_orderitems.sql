WITH src_sql_orderitems AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orderitems') }}
    ),

renamed as (

    select
        TRIM(order_id) AS order_id
        , TRIM(product_id) AS product_id
        , quantity
    from src_sql_orderitems

)

select * from renamed