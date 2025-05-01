-- Aggregated model optimized for queries by time period, district, and battalion


SELECT
    DATE_TRUNC('month', incident_date) AS time_period,
    district,
    battalion,
    COUNT(*) AS incident_count,
    COUNT(DISTINCT incident_id) AS unique_incidents
FROM "fire_incidents"."public_staging"."stg_fire_incidents"
GROUP BY
    DATE_TRUNC('month', incident_date),
    district,
    battalion