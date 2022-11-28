WITH src_sql_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

renamed as (
    select
        TRIM(event_id) AS event_id
        , TRIM(user_id) AS user_id
        , TRIM(session_id) AS session_id
        , TRIM(product_id) AS product_id
        , created_at
        , created_at ::DATE AS Created_at_date
        , TRIM(event_type) as event_type
        , TRIM(order_id) AS order_id 
        , TRIM(page_url) AS URL
    from src_sql_events
)
SELECT * FROM renamed