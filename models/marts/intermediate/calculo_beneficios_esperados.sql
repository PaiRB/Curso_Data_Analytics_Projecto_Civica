{{
  config(
    materialized='table'
  )
}}

WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheet_budget') }}
    ),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products')}}
),

renamed_casted AS (
    SELECT
          b.budget_id
        , p.name 
        , b.quantity
        , p.price
        , ROUND((quantity*price),2) AS stimated_sales
        , b.date
    FROM stg_budget b 
        JOIN stg_products p
        ON b.product_id = p.product_id
    )

SELECT * FROM renamed_casted