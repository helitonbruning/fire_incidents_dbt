{{
    config(
        materialized='incremental',
        schema='analytics',
        unique_key="district_id",
        incremental_strategy='merge',
        merge_update_columns=['last_updated_at']
    )
}}

WITH distinct_districts AS (
    SELECT
        DISTINCT
        {{ dbt_utils.generate_surrogate_key(['district', 'city', 'zipcode']) }} AS district_id,
        district,
        city,
        zipcode,
        loaded_at AS last_updated_at
    FROM {{ ref('stg_fire_incidents') }}
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(last_updated_at) FROM {{ this }})
    {% endif %}
)

SELECT
    district_id,
    district,
    city,
    zipcode,
    last_updated_at
FROM distinct_districts