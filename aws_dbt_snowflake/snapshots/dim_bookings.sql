{% snapshot dim_bookings %}

{{
    config(
      target_database='AIRBNB',
      target_schema='gold',
      unique_key='BOOKING_ID',
      strategy='timestamp',
      updated_at='CREATED_AT',
      dbt_valid_to_current="to_date('2099-12-31')"
    )
}}

select * from {{ ref('bookings') }}

{% endsnapshot %}
