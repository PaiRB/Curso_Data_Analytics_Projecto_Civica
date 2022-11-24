{{
  config(
    materialized='ephemeral'
  )
}}

WITH calculos_en_events AS (
    SELECT 
      count(distinct session_id) AS num_session
      , HOUR(created_at) AS created_hour
    FROM {{ ref('base_sql_server_dbo_events') }}
    GROUP BY 2
    )

SELECT AVG(num_session) AS Sesiones_Hora
FROM calculos_en_events

