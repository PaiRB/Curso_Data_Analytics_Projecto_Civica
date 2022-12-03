{{ 
    config(
        materialized='table',
        unique_key= 'id_anio_mes'
    ) 
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH meses AS (
    SELECT * 
    FROM {{ ref('stg_dates') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

SELECT
    -- ids
    id_anio_mes
    
    -- strings
    , desc_mes

    -- numerics
    , mes
    , CASE 
        WHEN mes-1 = 0 THEN 12 
        ELSE mes-1 
        END AS mes_previo
    , anio


from meses
order by
    id_anio_mes ASC