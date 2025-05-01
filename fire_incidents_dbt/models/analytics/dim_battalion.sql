{{
    config(
        materialized='incremental',
        schema='analytics',
        unique_key='battalion_id',
        incremental_strategy='merge',
    )
}}

WITH distinct_battalions AS (
    SELECT DISTINCT
        ROW_NUMBER() OVER (ORDER BY battalion, station_area) AS battalion_id,
        battalion,
        station_area,
        loaded_at AS last_updated_at
    FROM {{ ref('stg_fire_incidents') }}
    {% if is_incremental() %}
    WHERE incident_date >=  CURRENT_DATE - INTERVAL '7 days'
    {% endif %}
)

SELECT
    battalion_id,
    battalion,
    station_area,
    last_updated_at
FROM distinct_battalions
{% if is_incremental() %}
WHERE battalion || station_area NOT IN (SELECT battalion || station_area FROM {{ this }})
{% endif %}