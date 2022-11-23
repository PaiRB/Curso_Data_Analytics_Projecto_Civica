WITH src_sql_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

renamed as (
    select
        event_id
        , user_id
        , session_id 
        , product_id
        , created_at ::DATE AS Created_at_date
        , created_at ::TIME AS Created_at_time
        , event_type
        , order_id 
        , page_url AS URL
    from src_sql_events
)

select * from renamed