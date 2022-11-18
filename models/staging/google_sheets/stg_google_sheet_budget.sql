
{{
  config(
    materialized='table'
  )
}}

WITH src_budget_products AS (
    SELECT * 
    FROM {{ source('src_google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row AS budget_id
        , product_id
        , quantity AS Cantidad
        , month AS Mes
    FROM src_budget_products
    )

SELECT * FROM renamed_casted