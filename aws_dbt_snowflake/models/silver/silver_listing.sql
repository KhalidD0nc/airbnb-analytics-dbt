    {{ config(materialized='incremental', unique_key='listing_id') }}

    select 
        LISTING_ID,
        HOST_ID,
        ROOM_TYPE,
        PROPERTY_TYPE,
        CITY,
        COUNTRY,
        BEDROOMS,
        BATHROOMS,
        ACCOMMODATES,
        PRICE_PER_NIGHT,
        {{tag('CAST(PRICE_PER_NIGHT AS INT)')}} AS PRICE_PER_NIGHT_TAG,
        CREATED_AT
        
    from {{ ref('bronze_listings') }}   

