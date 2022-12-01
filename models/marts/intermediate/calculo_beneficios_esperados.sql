{{
  config(
    materialized='ephemeral',
    unique_key = 'budget_id'
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
        , b.natural_budget_id
        , p.product_id
        , p.name 
        , b.quantity
        , p.price_USD
        , ROUND((quantity*price_USD),2) AS stimated_sales_USD
        , b.date
        , (year(b.date)*100+month(b.date)) AS id_anio_mes
        , b.fivetran_synced
        
    FROM stg_budget b 
        JOIN stg_products p
        ON b.product_id = p.product_id
    )

SELECT * FROM renamed_casted

/*
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}
*/