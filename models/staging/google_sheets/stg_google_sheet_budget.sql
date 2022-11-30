{{
  config(
    materialized='view',
    unique_key='budget_id'
  )
}}

WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('base_google_sheet_budget') }}
    ),

renamed_casted AS (
    SELECT
      -- ids
      md5(_row) AS budget_id
      ,  TRIM(_row) AS natural_budget_id
      , md5(TRIM(product_id)) AS product_id

      -- numerics 
      , quantity
      
      -- dates
      , month AS date
      , monthname(month) AS month_desc
      , year(month) AS year_desc
      , (year(month)*100+month(b.month)) AS id_anio_mes
      
      -- timestamps
      , _fivetran_synced ::timestamp_ltz AS fivetran_synced
        
    FROM stg_budget b
    )

SELECT * FROM renamed_casted