SELECT * FROM {{ source('staging', 'hosts') }}
{% if is_incremental() %}
    -- If MAX is NULL, use a very old date so all data is pulled
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }})
{% endif %}