{{
  config(
    materialized='view'
  )
}}

WITH marketing_events AS (
    SELECT 
     * 
    FROM {{ ref('marketing_users_vistas_paginas') }}
    ),

renamed_casted AS (
    SELECT
        DISTINCT e.user_id
        , e.client_full_name
        , e.email
        , age
        , gender
        , product_name
        , SUM(minutos_duracion) AS total_minutos_visitas
        , SUM(page_view) AS total_page_view
        , SUM(add_to_cart) AS total_add_to_cart
        , SUM(checkout) AS total_checkout
        , SUM(package_shipped) AS total_package_shipped
        , SUM(youtube_ads) AS from_youtube_ads
        , SUM(youtube_promo) AS from_youtube_promo
        , SUM(instagram_profile) AS from_instagram_profile
        , SUM(google_search) AS from_google_search

    FROM marketing_events e
    {{ dbt_utils.group_by(6)}}
    )

SELECT * FROM renamed_casted
ORDER BY client_full_name ASC