{{
  config(
    materialized='ephemeral'
  )
}}

WITH calculo_beneficios_esperados AS (
    SELECT * 
    FROM {{ ref('calculo_beneficios_esperados') }}
    ),

conteo_ventas_producto AS (
    SELECT 
      *
    FROM {{ ref('conteo_ventas_producto') }}
    ),

renamed_casted AS (
    SELECT
        -- ids
        cal.id_anio_mes
        , cal.budget_id
        , cal.natural_budget_id
        , cal.product_id

        -- strings
        , cal.name

        -- numerics 
        , cal.quantity
        , con.quantity_sold
        , cal.price_USD
        , cal.stimated_sales_USD
        , con.sales_USD
        , con.discount_USD
        , (con.sales_USD-con.discount_USD) AS real_sales_USD
        , con.provider_cost_USD
        , ((con.sales_USD-con.discount_USD)-con.provider_cost_USD) AS profit

        -- timestamps

        , cal.fivetran_synced

    FROM calculo_beneficios_esperados cal
        LEFT JOIN conteo_ventas_producto con
        ON (cal.product_id = con.product_id)
        AND (con.id_anio_mes = cal.id_anio_mes)

    )

SELECT * FROM renamed_casted