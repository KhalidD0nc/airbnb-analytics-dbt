{{ config(materialized='incremental', unique_key="booking_id") }}

select 
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE, 
    NIGHTS_BOOKED,
    BOOKING_AMOUNT,
    CLEANING_FEE,
    SERVICE_FEE,
    {{multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2)}} + CLEANING_FEE + SERVICE_FEE as TOTAL_AMOUNT,
    BOOKING_STATUS,
    CREATED_AT
FROM {{ ref('bronze_bookings') }}




