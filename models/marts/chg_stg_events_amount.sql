{% set event_types = obtener_valores(ref('stg_sql_server_dbo_events'),'event_type') %}
WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        {%- for event_type in event_types   %}
        sum(case when event_type = '{{event_type}}' then 1 end) as {{event_type}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events
    GROUP BY 1
    )

SELECT count(user_id)
    , SUM(page_view_amount)
    , SUM(add_to_cart_amount)
    , SUM(checkout_amount)
    , SUM(package_shipped_amount) 
FROM renamed_casted