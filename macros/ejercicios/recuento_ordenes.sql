WITH stg_orders AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

compras_usuarios AS (
    SELECT
        user_id
        , count(distinct order_id) as num_compras
    FROM stg_orders
    GROUP BY 1
    ),

user_por_compra AS(
    SELECT
        CASE
        WHEN num_compras >= 3 THEN '3+'
        ELSE num_compras::VARCHAR
        END AS num_compras
        , count(user_id) as num_users
    FROM compras_usuarios
    GROUP BY 1
)

SELECT * FROM user_por_compra