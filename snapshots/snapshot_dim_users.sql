{% snapshot snapshot_dim_user %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',

      strategy='timestamp',
      updated_at='fivetran_synced'
    )
}}

select * from {{ ref('dim_users') }}

{% endsnapshot %}