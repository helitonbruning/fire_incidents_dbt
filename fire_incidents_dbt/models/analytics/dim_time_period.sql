{{
    config(
        materialized='incremental',
        schema='analytics',
        unique_key='time_period_id',
        incremental_strategy='merge',
        merge_update_columns=['last_updated_at']
    )
}}

WITH distinct_dates AS (
    SELECT DISTINCT
        incident_date,
        loaded_at
    FROM {{ ref('stg_fire_incidents') }}
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(last_updated_at) FROM {{ this }})
    {% endif %}
),

time_periods AS (
    SELECT
        DISTINCT
        {{ dbt_utils.generate_surrogate_key(['incident_date']) }} AS time_period_id,
        incident_date,
        EXTRACT(YEAR FROM incident_date) AS incident_year,
        TO_CHAR(incident_date, 'YYYY-MM') AS incident_month,
        CONCAT(EXTRACT(YEAR FROM incident_date), '-Q', EXTRACT(QUARTER FROM incident_date)) AS incident_quarter,
        loaded_at AS last_updated_at
    FROM distinct_dates
)

SELECT
    time_period_id,
    incident_date,
    incident_year,
    incident_month,
    incident_quarter,
    last_updated_at
FROM time_periods