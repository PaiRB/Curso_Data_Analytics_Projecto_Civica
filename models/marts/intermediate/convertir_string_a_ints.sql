{{
  config(
    materialized='ephemeral'
  )
}}

WITH ref_users AS (
    SELECT * 
    FROM {{ ref('dim_users') }}
    )

SELECT 
    -- ids
    user_id
    , address_id

    -- strings
    , CONCAT(first_name,' ',last_name) AS Client_Name
    , UNICODE(trim(first_name))
    , ROUND((UNICODE(trim(last_name))/2),0)
    , UNICODE(user_id) % 2 AS testeo 
    , CASE
        WHEN UNICODE(user_id)<75 THEN 'F'
        ELSE 'M'
        END AS gender
    


FROM ref_users