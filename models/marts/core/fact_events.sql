{{
  config(
    materialized='table',
    unique_key = 'event_id',
    on_schema_change = 'append_new_columns'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH fact_events AS (
    SELECT * 
    FROM {{ ref('intermediate_events') }}
    ),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
        -- ids
        event_id
        , natural_event_id
        , user_id
        , session_id
        , product_id
        , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date


        -- strings
        , product_name
        , event_type
        , url
        , dispositve_type
        , CASE
            WHEN from_page <= 0.1 THEN 'youtube_ads'
            WHEN from_page between 0.11 AND 0.3 THEN 'youtube_promo'
            WHEN from_page between 0.31 AND 0.5 THEN 'instagram_profile'
            ELSE 'google_search'
          END AS from_page

        -- timestamps
        , created_at

    FROM fact_events

    )

SELECT * FROM renamed_casted


{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}