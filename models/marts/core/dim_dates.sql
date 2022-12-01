{{ 
    config(
        materialized='table', 
    ) 
}}

WITH date AS (
    SELECT * 
    FROM {{ ref('stg_dates') }}
    )

SELECT
    fecha_forecast
    , id_date
    , anio
    , mes
    , desc_mes
    , dia_previo
    , anio_semana_dia
    , semana
from date
order by
    fecha_forecast ASC