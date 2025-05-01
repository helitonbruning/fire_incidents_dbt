{{
    config(
        materialized='incremental',
        schema='analytics',
        unique_key='battalion_id',
        incremental_strategy='merge',
        merge_update_columns=['last_updated_at']
    )
}}

WITH distinct_battalions AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['battalion', 'station_area']) }} AS battalion_id,
        battalion,
        station_area,
        loaded_at AS last_updated_at
    FROM {{ ref('stg_fire_incidents') }}
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(last_updated_at) FROM {{ this }})
    {% endif %}
)

SELECT
    battalion_id,
    battalion,
    station_area,
    last_updated_at
FROM distinct_battalions