// IF Else
{% set flag = 1 %}

SELECT * FROM {{ ref('bronze_bookings') }} 
{% if flag == 1 %} 
    WHERE NIGHTS_BOOKED > 1
{% else %}
    WHERE NIGHTS_BOOKED = 1
{% endif %}



//For Loop

{% set cols = ['NIGHTS_BOOKED', 'BOOKING_ID', 'BOOKING_AMOUNT'] %}

{% for col in cols %}
    SELECT {{ col }} FROM {{ ref('bronze_bookings') }}
{% endfor %}