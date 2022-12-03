{{
  config(
    materialized='view'
  )
}}

WITH stg_events AS (
    SELECT 
     * 
    FROM {{ ref('marketing_users_vistas_paginas') }}
    ),

ref_user AS (
    SELECT 
     * 
    FROM {{ ref('dim_users') }}
    ),

renamed_casted AS (
    SELECT
        DISTINCT e.user_id
        , CONCAT(e.first_name,' ',e.last_name) AS client_name
        , e.email
        , age
        , gender
        , SUM(minutos_duracion) AS total_minutos_visitas
        , SUM(page_view) AS total_page_view
        , SUM(add_to_cart) AS total_add_to_cart
        , SUM(checkout) AS total_checkout
        , SUM(package_shipped) AS total_package_shipped
        , SUM(youtube_ads) AS from_youtube_ads
        , SUM(youtube_promo) AS from_youtube_promo
        , SUM(instagram_profile) AS from_instagram_profile
        , SUM(google_search) AS from_google_search

    FROM stg_events e
        JOIN dim_users u
        ON e.user_id = u.user_id
    {{ dbt_utils.group_by(5)}}
    )

SELECT * FROM renamed_casted
ORDER BY client_name ASC