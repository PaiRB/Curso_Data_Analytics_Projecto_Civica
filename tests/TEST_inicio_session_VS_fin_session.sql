WITH marketing_visitas AS (
    SELECT * 
    FROM {{ ref('marketing_users_vistas_paginas') }}
    )

SELECT
    -- ids
    session_id

    -- timestamps
    ,inicio_session
    , fin_session

FROM marketing_visitas
WHERE inicio_session > fin_session