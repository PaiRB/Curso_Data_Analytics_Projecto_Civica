{{
  config(
    materialized='incremental',
    unique_key = 'user_id'
  )
}}

WITH ref_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

ref_calculo_orders AS (
    SELECT 
        user_id
        , num_orders
    FROM {{ ref('calculo_orders_por_user') }}
    ),

users as (

    select
        user_id
        , first_name
        , last_name
        --, age // RETIRADO HASTA SOLUCIONAR INCREMENTAL
        --, gender // RETIRADO HASTA SOLUCIONAR INCREMENTAL
        , total_orders
        , created_at
        , created_date
        , updated_at
        , updated_date
        , phone_number
        , email
        , address_id
        , fivetran_synced

    from ref_users
),

calculo_orders as (
    select
        user_id
        , num_orders
    from ref_calculo_orders
)

SELECT u.user_id
    , u.first_name
    , u.last_name
    --, gender // RETIRADO HASTA SOLUCIONAR INCREMENTAL
    --, age // RETIRADO HASTA SOLUCIONAR INCREMENTAL
    , coalesce(co.num_orders, 0) AS total_orders
    , u.phone_number
    , u.email
    , u.address_id
    , u.created_at
    , u.created_date
    , u.updated_at
    , u.updated_date
    , u.fivetran_synced

FROM users u 
    LEFT JOIN calculo_orders co
    ON u.user_id = co.user_id

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where fivetran_synced > (select max(fivetran_synced) from {{ this }})

{% endif %}