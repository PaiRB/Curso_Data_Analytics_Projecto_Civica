{% snapshot snapshot_dim_products %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',

      strategy='check',
      check_cols=['price_USD','inventory','fivetran_synced'],
    )
    
}}

select * from {{ ref('dim_products') }}

{% endsnapshot %}