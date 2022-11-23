WITH src_sql_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_events') }}
    ),

renamed as (
    select
        event_id
        , user_id
        , session_id 
        , product_id
        , created_at ::DATE AS Created_at_date
        , created_at ::TIME AS Created_at_time
        , event_type
        , order_id 
        , page_url AS URL
    from src_sql_events
)

/*
select count(DISTINCT(order_id)) AS Num_pedidos_distintos
from renamed
*/

/*
select event_id, user_id, event_type, order_id 

from renamed

WHERE order_id <> ''
ORDER BY order_id
*/

select COUNT(event_type)
FROM renamed
WHERE event_type = 'checkout'
UNION
select COUNT(event_type)
FROM renamed
WHERE event_type = 'package_shipped'
