{{
  config(
    materialized='table'
  )
}}

WITH calculo_budgets AS (
    SELECT * 
    FROM {{ ref('fact_budget') }}
    ),

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

renamed_casted AS (
    SELECT
        -- ids
        id_anio_mes

        -- numerics 
        , SUM(stimated_sales_USD) AS stimated_sales_USD
        , SUM(sales_USD) AS sales_USD
        , SUM(discount_USD) AS discount_USD
        , SUM(real_sales_USD) AS sales_minus_discounts_USD
        , SUM(provider_cost_USD) AS provider_cost_USD
        , SUM(profit) AS profit_USD

    FROM calculo_budgets

    GROUP BY id_anio_mes
    ORDER BY id_anio_mes ASC

    )

SELECT * FROM renamed_casted