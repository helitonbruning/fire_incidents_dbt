

WITH distinct_battalions AS (
    SELECT DISTINCT
        ROW_NUMBER() OVER (ORDER BY battalion, station_area) AS battalion_id,
        battalion,
        station_area,
        loaded_at AS last_updated_at
    FROM "fire_incidents"."public_staging"."stg_fire_incidents"
    
    WHERE incident_date >=  CURRENT_DATE - INTERVAL '7 days'
    
)

SELECT
    battalion_id,
    battalion,
    station_area,
    last_updated_at
FROM distinct_battalions

WHERE battalion || station_area NOT IN (SELECT battalion || station_area FROM "fire_incidents"."public_analytics"."dim_battalion")
