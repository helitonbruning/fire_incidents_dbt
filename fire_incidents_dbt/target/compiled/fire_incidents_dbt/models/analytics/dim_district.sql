

WITH distinct_districts AS (
    SELECT DISTINCT
        ROW_NUMBER() OVER (ORDER BY district, city, zipcode) AS district_id,
        district,
        city,
        zipcode,
        loaded_at AS last_updated_at
    FROM "fire_incidents"."public_staging"."stg_fire_incidents"
    WHERE incident_date >= CURRENT_DATE - INTERVAL '7 days'
)

SELECT
    district_id,
    district,
    city,
    zipcode,
    last_updated_at
FROM distinct_districts

WHERE district || city || zipcode NOT IN (SELECT district || city || zipcode FROM "fire_incidents"."public_analytics"."dim_district")
