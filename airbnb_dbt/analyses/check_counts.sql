SELECT 'bronze_bookings' as table_name, count(*) as row_count FROM {{ ref('bronze_bookings') }}
UNION ALL
SELECT 'silver_bookings' as table_name, count(*) as row_count FROM {{ ref('silver_bookings') }}
