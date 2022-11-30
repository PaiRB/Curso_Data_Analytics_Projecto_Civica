{{
  config(
    materialized='ephemeral'
  )
}}

WITH stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

datos_orderitems AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_orderitems') }}
    ),

datos_promos AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    ),

datos_order AS (
    SELECT 
      *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    SELECT
      -- ids
      (year(o.created_date)*100+month(o.created_date)) AS id_anio_mes
      , oit.product_id

      -- strings
      , p.name

      -- numerics
      , SUM(oit.quantity) AS quantity_sold
      , p.price_USD
      , SUM(oit.quantity*p.price_USD) AS sales_USD
      , SUM(pro.discount_USD) AS discount_USD
      , SUM(oit.quantity*p.provider_price_USD) AS provider_cost_USD

    FROM datos_order o
      LEFT JOIN datos_orderitems oit
      ON o.order_id = oit.order_id
      LEFT JOIN stg_products p
      ON oit.product_id = p.product_id 
      LEFT JOIN datos_promos pro
      ON o.promo_id = pro.promo_id

    GROUP BY 
      id_anio_mes
      , oit.product_id
      , p.name
      , p.price_USD

    )

SELECT * FROM renamed_casted