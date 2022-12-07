{% snapshot snapshot_fact_orders %}

{{
    config(
      target_schema='snapshots',
      unique_key='fact_order_id',

      strategy='timestamp',
      updated_at='fivetran_synced'
    )
}}

select * from {{ ref('fact_orders') }}

{% endsnapshot %}