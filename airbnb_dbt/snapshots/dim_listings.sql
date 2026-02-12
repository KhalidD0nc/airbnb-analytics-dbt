{% snapshot dim_listings %}

{{
   config(
       target_database='AIRBNB',
       target_schema='gold',
       unique_key='LISTING_ID',

       strategy='timestamp',
       updated_at='LISTING_CREATED_AT',
       dbt_valid_to_current="to_date('2099-12-31')"
   )
}}

SELECT * FROM {{ ref('listings') }}
{% endsnapshot %}