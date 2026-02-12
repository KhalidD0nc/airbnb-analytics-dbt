{% set configs = [ 

{ 
    "table" : "AIRBNB.GOLD.OBT",
    "columns" : "GOLD_OBT.BOOKING_ID, GOLD_OBT.LISTING_ID, GOLD_OBT.HOST_ID, GOLD_OBT.BOOKING_DATE, GOLD_OBT.NIGHTS_BOOKED, GOLD_OBT.BOOKING_AMOUNT, GOLD_OBT.CLEANING_FEE, GOLD_OBT.SERVICE_FEE, GOLD_OBT.TOTAL_AMOUNT, GOLD_OBT.CREATED_AT, GOLD_OBT.ACCOMMODATES, GOLD_OBT.BEDROOMS, GOLD_OBT.BATHROOMS, GOLD_OBT.PRICE_PER_NIGHT, GOLD_OBT.HOST_SINCE,  GOLD_OBT.RESPONSE_RATE,  GOLD_OBT.LISTING_CREATED_AT",
    "alias" : "GOLD_OBT"
},
{ 
    "table" : "AIRBNB.GOLD.DIM_LISTINGS",
    "columns" : "",
    "alias" : "DIM_LISTINGS",
    "join_condition" : "GOLD_OBT.listing_id = DIM_LISTINGS.listing_id"
},
{
    "table" : "AIRBNB.GOLD.DIM_HOSTS",
    "columns" : "",
    "alias" : "DIM_HOSTS",
    "join_condition" : "GOLD_OBT.host_id = DIM_HOSTS.host_id"
}
]%}

SELECT 
{{ configs[0]['columns']}}
FROM
{% for config in configs %}
{% if loop.first %}
{{ config['table'] }} AS {{ config['alias'] }}
{% else %}
LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
ON {{ config['join_condition'] }}
{% endif %}
{% endfor %}