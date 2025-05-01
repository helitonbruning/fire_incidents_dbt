

WITH fire_incidents AS (
    SELECT
        s.incident_id,
        s.call_number,
        s.exposure_number,
        s.suppression_units,
        s.suppression_personnel,
        s.ems_units,
        s.ems_personnel,
        s.other_units,
        s.other_personnel,
        s.estimated_property_loss,
        s.estimated_contents_loss,
        s.fire_fatalities,
        s.fire_injuries,
        s.civilian_fatalities,
        s.civilian_injuries,
        s.number_of_alarms,
        s.number_of_floors_with_minimum_damage,
        s.number_of_floors_with_significant_damage,
        s.number_of_floors_with_heavy_damage,
        s.incident_date,
        s.district,
        s.city,
        s.zipcode,
        s.battalion,
        s.station_area,
        s.loaded_at
    FROM "fire_incidents"."public_staging"."stg_fire_incidents" s
    WHERE s.incident_date >= CURRENT_DATE - INTERVAL '7 days'
),
joined AS (
    SELECT
        t.time_period_id,
        d.district_id,
        b.battalion_id,
        f.incident_id,
        f.call_number,
        f.exposure_number,
        f.suppression_units,
        f.suppression_personnel,
        f.ems_units,
        f.ems_personnel,
        f.other_units,
        f.other_personnel,
        f.estimated_property_loss,
        f.estimated_contents_loss,
        f.fire_fatalities,
        f.fire_injuries,
        f.civilian_fatalities,
        f.civilian_injuries,
        f.number_of_alarms,
        f.number_of_floors_with_minimum_damage,
        f.number_of_floors_with_significant_damage,
        f.number_of_floors_with_heavy_damage,
        f.loaded_at AS last_updated_at
    FROM fire_incidents f
    LEFT JOIN "fire_incidents"."public_analytics"."dim_time_period" t
        ON f.incident_date = t.incident_date
    LEFT JOIN "fire_incidents"."public_analytics"."dim_district" d
        ON f.district = d.district
        AND f.city = d.city
        AND f.zipcode = d.zipcode
    LEFT JOIN "fire_incidents"."public_analytics"."dim_battalion" b
        ON f.battalion = b.battalion
        AND f.station_area = b.station_area
    GROUP BY f.incident_id,
        t.time_period_id,
        d.district_id,
        b.battalion_id,
        f.call_number,
        f.exposure_number,
        f.suppression_units,
        f.suppression_personnel,
        f.ems_units,
        f.ems_personnel,
        f.other_units,
        f.other_personnel,
        f.estimated_property_loss,
        f.estimated_contents_loss,
        f.fire_fatalities,
        f.fire_injuries,
        f.civilian_fatalities,
        f.civilian_injuries,
        f.number_of_alarms,
        f.number_of_floors_with_minimum_damage,
        f.number_of_floors_with_significant_damage,
        f.number_of_floors_with_heavy_damage,
        f.loaded_at
)

SELECT
    time_period_id,
    district_id,
    battalion_id,
    incident_id,
    call_number,
    exposure_number,
    suppression_units,
    suppression_personnel,
    ems_units,
    ems_personnel,
    other_units,
    other_personnel,
    estimated_property_loss,
    estimated_contents_loss,
    fire_fatalities,
    fire_injuries,
    civilian_fatalities,
    civilian_injuries,
    number_of_alarms,
    number_of_floors_with_minimum_damage,
    number_of_floors_with_significant_damage,
    number_of_floors_with_heavy_damage,
    last_updated_at
FROM joined
