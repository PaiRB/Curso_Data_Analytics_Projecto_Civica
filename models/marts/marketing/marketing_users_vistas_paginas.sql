{{
  config(
    materialized='view'
  )
}}

{% set event_types = obtener_valores(ref('base_sql_server_dbo_events'),'event_type') %}
WITH stg_events AS (
    SELECT 
     * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

datos_user AS (
    SELECT 
      *
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

renamed_casted AS (
    SELECT
        e.user_id
        , e.session_id
        , d.first_name
        , d.last_name
        , d.email
        , min(e.created_at) as inicio_session
        , max(e.created_at) as fin_session
        , datediff(minute, min(e.created_at), max(e.created_at)) AS minutos_duracion 
        ,
        {%- for event_type in event_types   %}
        coalesce(sum(case when event_type = '{{event_type}}' then 1 end),0) as {{event_type}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events e
    JOIN datos_user d
    ON e.user_id = d.user_id
    {{ dbt_utils.group_by(5)}}
    )

SELECT * FROM renamed_casted
