{{
  config(
    materialized='table',
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
        -- ids
        user_id
        , address_id

        -- strings
        , first_name
        , last_name
        , phone_number
        , email

        -- numerics
        , total_orders

        -- timestamps
        , created_at
        , created_date
        , updated_at
        , updated_date
        , fivetran_synced

    from ref_users
),

calculo_orders as (
    select
        user_id
        , num_orders
    from ref_calculo_orders
)

SELECT 
    -- ids
    u.user_id
    , u.address_id

    -- strings
    , u.first_name
    , u.last_name
    , u.phone_number
    , u.email
    , CASE
        WHEN UNICODE(u.user_id)<75 THEN 'F'
        ELSE 'M'
        END AS gender

    -- numerics
    , (UNICODE(trim(first_name))-ROUND((UNICODE(trim(last_name))/2),0)) AS age
    , coalesce(co.num_orders, 0) AS total_orders

    -- timestamps
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