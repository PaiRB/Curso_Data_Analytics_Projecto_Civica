{{
  config(
    materialized='view'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

{% set event_types = obtener_valores(ref('fact_events'),'event_type') %}
{% set from_pages = obtener_valores(ref('fact_events'),'from_page') %}

WITH stg_events AS (
    SELECT 
     * 
    FROM {{ ref('fact_events') }}
    ),

datos_user AS (
    SELECT 
      *
    FROM {{ ref('dim_users') }}
    ),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
        e.user_id
        , e.session_id
        , u.client_full_name
        , u.email
        , min(e.created_at) as inicio_session
        , max(e.created_at) as fin_session
        , datediff(minute, min(e.created_at), max(e.created_at)) AS minutos_duracion 
        ,
        {%- for event_type in event_types   %}
        coalesce(sum(case when event_type = '{{event_type}}' then 1 end),0) as {{event_type}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
        ,
        {%- for from_page in from_pages   %}
        coalesce(sum(case when from_page = '{{from_page}}' then 1 end),0) as {{from_page}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events e
    JOIN datos_user u
    ON e.user_id = u.user_id
    {{ dbt_utils.group_by(4)}}
    )

SELECT * FROM renamed_casted
ORDER BY client_full_name ASC