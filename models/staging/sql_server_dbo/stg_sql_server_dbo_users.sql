{{
  config(
    materialized='view',
    unique_key='user_id'
  )
}}

WITH src_sql_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),

/*--------------------------------------------------
----RETIRADO HASTA SOLUCIONAR LA INGESTA------------
----------------------------------------------------
age_gender AS (
    SELECT
        user_id 
        , CAST(age AS NUMBER(38,0)) AS age  
        , gender
    FROM {{ref('age_gender_of_users')}}
),
*/
renamed as (

    select
        -- ids
        md5(u.user_id) AS user_id
        , TRIM(u.user_id) AS natural_user_id

        -- strings
        , TRIM(first_name) AS first_name 
        , TRIM(last_name) AS last_name
        --, gender //RETIRADO HASTA SOLUCIONAR LA INGESTA
        , TRIM(phone_number) AS phone_number
        , TRIM(email) AS email
        , TRIM(address_id) AS address_id

        -- numerics
        --, age //RETIRADO HASTA SOLUCIONAR LA INGESTA
        , total_orders

        -- timestamps
        , created_at ::timestamp_ltz AS created_at
        , created_at ::DATE AS created_date
        , updated_at ::timestamp_ltz AS updated_at
        , updated_at ::DATE AS updated_date
        , _fivetran_synced ::timestamp_ltz AS fivetran_synced

    from src_sql_users u 
        --join age_gender s
        --on u.user_id = s.user_id
)

select * from renamed