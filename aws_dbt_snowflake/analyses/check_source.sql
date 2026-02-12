SELECT 
    'source_bookings' as table_name,
    count(*) as total_rows,
    count(CREATED_AT) as non_null_created_at
FROM {{ source('staging', 'bookings') }}
