
  create view "fire_incidents"."public_analytics"."vw_fact_fire_incidents_summary__dbt_tmp"
    
    
  as (
    

SELECT
    time_period_id,
    district_id,
    battalion_id,
    COUNT(*) AS total_incidents,
    COUNT(DISTINCT call_number) AS distinct_call_numbers,
    SUM(suppression_units) AS total_suppression_units,
    SUM(suppression_personnel) AS total_suppression_personnel,
    SUM(ems_units) AS total_ems_units,
    SUM(ems_personnel) AS total_ems_personnel,
    SUM(other_units) AS total_other_units,
    SUM(other_personnel) AS total_other_personnel,
    SUM(estimated_property_loss) AS total_estimated_property_loss,
    SUM(estimated_contents_loss) AS total_estimated_contents_loss,
    SUM(fire_fatalities) AS total_fire_fatalities,
    SUM(fire_injuries) AS total_fire_injuries,
    SUM(civilian_fatalities) AS total_civilian_fatalities,
    SUM(civilian_injuries) AS total_civilian_injuries,
    AVG(number_of_alarms) AS avg_number_of_alarms,
    AVG(number_of_floors_with_minimum_damage) AS avg_floors_with_minimum_damage,
    AVG(number_of_floors_with_significant_damage) AS avg_floors_with_significant_damage,
    AVG(number_of_floors_with_heavy_damage) AS avg_floors_with_heavy_damage,
    MAX(last_updated_at) AS last_updated_at
FROM "fire_incidents"."public_analytics"."fact_fire_incidents"
GROUP BY time_period_id, district_id, battalion_id
  );