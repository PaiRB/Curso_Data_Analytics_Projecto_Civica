{{
  config(
    materialized='view',
    unique_key='event_id'
  )
}}

WITH src_sql_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

renamed as (
    select
        -- ids
        md5(event_id) AS event_id
        , TRIM(event_id) AS natural_event_id
        , md5(TRIM(user_id)) AS user_id
        , TRIM(session_id) AS session_id
        , md5(TRIM(product_id)) AS product_id
        , md5(TRIM(order_id)) AS order_id
        , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date_created

        -- strings
        , TRIM(event_type) as event_type
        , TRIM(page_url) AS URL

        -- timestamps
        , created_at::timestamp_ltz AS created_at
        , created_at ::DATE AS Created_at_date
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced

    from src_sql_events
)
SELECT * FROM renamed