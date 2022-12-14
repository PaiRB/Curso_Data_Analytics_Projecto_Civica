{{ 
    config(
        materialized='table',
        unique_key = 'id_date' 
    ) 
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH date AS (
    SELECT * 
    FROM {{ ref('stg_dates') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

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