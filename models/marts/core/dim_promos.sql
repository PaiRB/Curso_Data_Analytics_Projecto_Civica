WITH stg_sql_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    )

select * from stg_sql_promos