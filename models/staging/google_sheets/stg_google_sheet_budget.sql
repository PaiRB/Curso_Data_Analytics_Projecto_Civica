{{
  config(
    materialized='table'
  )
}}

WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('base_google_sheet_budget') }}
    ),

renamed_casted AS (
    SELECT
          _row AS budget_id
        , product_id
        , quantity
        , monthname(month) as month_desc
        , year(month) as year_desc
    FROM stg_budget
    )

SELECT * FROM renamed_casted