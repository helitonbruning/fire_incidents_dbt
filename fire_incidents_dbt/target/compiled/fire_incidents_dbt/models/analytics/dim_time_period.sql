
WITH distinct_dates AS (
    SELECT DISTINCT
        incident_date,
        loaded_at
    FROM "fire_incidents"."public_staging"."stg_fire_incidents"
    WHERE incident_date >= CURRENT_DATE - INTERVAL '7 days'
),
time_periods AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY incident_date) AS time_period_id,
        incident_date,
        EXTRACT(YEAR FROM incident_date) AS incident_year,
        TO_CHAR(incident_date, 'YYYY-MM') AS incident_month,
        CONCAT(EXTRACT(YEAR FROM incident_date), '-Q', EXTRACT(QUARTER FROM incident_date)) AS incident_quarter,
        loaded_at AS last_updated_at
    FROM distinct_dates
)

SELECT * FROM time_periods

WHERE incident_date NOT IN (SELECT incident_date FROM "fire_incidents"."public_analytics"."dim_time_period")
