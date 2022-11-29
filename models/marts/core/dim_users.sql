{{
  config(
    materialized='table'
  )
}}

WITH ref_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

ref_calculo_orders AS (
    SELECT * 
    FROM {{ ref('calculo_orders_por_user') }}
    ),

users as (

    select
        user_id
        , first_name
        , last_name
        , age
        , gender
        , total_orders
        , created_at
        , created_date
        , updated_at
        , updated_date
        , phone_number
        , email
        , address_id

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
    , u.gender
    , u.age
    , coalesce(co.num_orders, 0) AS total_orders
    , u.phone_number
    , u.email
    , u.address_id
    , u.created_at
    , u.created_date
    , u.updated_at
    , u.updated_date

FROM users u 
    LEFT JOIN calculo_orders co
    ON u.user_id = co.user_id