{{
  config(
    materialized='ephemeral',
    unique_key = 'budget_id'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheet_budget') }}
    ),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products')}}
),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
        -- ids
        b.budget_id
        , b.natural_budget_id
        , p.product_id
        , id_anio_mes

        -- strings
        , p.name

        -- numerics 
        , b.quantity
        , p.price_USD
        , ROUND((quantity*price_USD),2) AS stimated_sales_USD

        -- timestamps
        , b.date
        , b.fivetran_synced
        
    FROM stg_budget b 
        JOIN stg_products p
        ON b.product_id = p.product_id
    )

SELECT * FROM renamed_casted