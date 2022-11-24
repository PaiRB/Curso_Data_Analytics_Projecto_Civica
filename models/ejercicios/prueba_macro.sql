{{
  config(
    materialized='ephemeral'
  )
}}

{% set event_types = obtener_valores(ref('base_sql_server_dbo_events'),'event_type') %}
WITH stg_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

renamed_casted AS (
    SELECT
        user_id
        ,
        {%- for event_type in event_types   %}
        coalesce(sum(case when event_type = '{{event_type}}' then 1 end),0) as {{event_type}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events 
    GROUP BY user_id
    )

SELECT * FROM renamed_casted

