{{
  config(
    materialized='table'
  )
}}

WITH src_sql_addresses AS (
    SELECT * 
    FROM {{ source('src_sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id
        , zipcode AS Codigo_Postal
        , country AS Pais
        , address AS Direccion
        , state AS Estado
    FROM src_sql_addresses
    )

SELECT * FROM renamed_casted