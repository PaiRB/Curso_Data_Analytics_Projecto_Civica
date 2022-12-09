{% snapshot snapshot_dim_products %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',

      strategy='timestamp',
      updated_at='fivetran_synced'
    )
}}

select * from {{ ref('dim_products') }}

{% endsnapshot %}