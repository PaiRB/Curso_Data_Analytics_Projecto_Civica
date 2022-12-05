{{
  config(
    materialized='incremental',
    unique_key = 'promo_id',
    on_schema_change = 'append_new_columns'
  )
}}

---------------------------------------------------------------------
--------------------------REFERENCES TO STG--------------------------
---------------------------------------------------------------------

WITH stg_sql_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    )

---------------------------------------------------------------------
-------------------------------SELECTS-------------------------------
---------------------------------------------------------------------

select * from stg_sql_promos

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}