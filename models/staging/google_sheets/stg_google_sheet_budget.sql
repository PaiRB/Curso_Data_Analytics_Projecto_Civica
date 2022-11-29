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
          TRIM(_row) AS budget_id
        , TRIM(product_id) AS product_id 
        , quantity
        , month AS date
        , monthname(month) AS month_desc
        , year(month) AS year_desc
        , _fivetran_synced
    FROM stg_budget
    )

SELECT * FROM renamed_casted