{{
  config(
    materialized='table'
  )
}}

WITH src_sql_events AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'events') }}
    ),

renamed as (

    select
        event_id
        , user_id
        , session_id 
        , product_id
        , created_at AS Fecha_evento
        , event_type AS Tipo_evento
        , order_id 
        , page_url AS URL
    from src_sql_events

)

select * from renamed