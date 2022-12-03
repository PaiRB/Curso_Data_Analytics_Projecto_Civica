{{
  config(
    materialized='view'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH fact_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events') }}
    ),

fact_products AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

fact_users AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
        -- ids
        e.event_id
        , e.natural_event_id
        , u.user_id
        , e.session_id
        , p.product_id


        -- strings
        , p.name AS product_name
        , e.event_type
        , e.url
        , CASE
          WHEN TRIM(UNICODE(natural_event_id)) >=55 THEN 'smart_phone'
          ELSE 'personal_computer'
          END AS dispositve_type

        -- numerics 
        , CAST(TRIM(UNICODE(session_id))+COALESCE(TRIM(UNICODE(p.name)),0) AS NUMBER(38,2))%1.1 AS from_page

        -- timestamps
        , e.created_at

    FROM fact_events e
        LEFT JOIN fact_users u
        ON e.user_id = u.user_id
        LEFT JOIN fact_products p
        ON e.product_id = p.product_id

    )

SELECT * FROM renamed_casted
