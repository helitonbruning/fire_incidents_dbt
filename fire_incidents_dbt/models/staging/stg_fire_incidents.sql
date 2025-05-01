{% set raw_table_ref = source('raw', 'fire_incidents_raw') %}

{{
    config(
        materialized='incremental',
        schema='staging',
        unique_key='incident_id',
        incremental_strategy='merge',
    )
}}

SELECT
    incident_id,
    TRIM(NULLIF(call_number, '')) AS call_number,
    CAST(NULLIF(exposure_number, '') AS INTEGER) AS exposure_number,
    CAST(NULLIF(suppression_units, '') AS INTEGER) AS suppression_units,
    CAST(NULLIF(suppression_personnel, '') AS INTEGER) AS suppression_personnel,
    CAST(NULLIF(ems_units, '') AS INTEGER) AS ems_units,
    CAST(NULLIF(ems_personnel, '') AS INTEGER) AS ems_personnel,
    CAST(NULLIF(other_units, '') AS INTEGER) AS other_units,
    CAST(NULLIF(other_personnel, '') AS INTEGER) AS other_personnel,
    CAST(NULLIF(estimated_property_loss, '') AS NUMERIC) AS estimated_property_loss,
    CAST(NULLIF(estimated_contents_loss, '') AS NUMERIC) AS estimated_contents_loss,
    CAST(NULLIF(fire_fatalities, '') AS INTEGER) AS fire_fatalities,
    CAST(NULLIF(fire_injuries, '') AS INTEGER) AS fire_injuries,
    CAST(NULLIF(civilian_fatalities, '') AS INTEGER) AS civilian_fatalities,
    CAST(NULLIF(civilian_injuries, '') AS INTEGER) AS civilian_injuries,
    CAST(NULLIF(number_of_alarms, '') AS INTEGER) AS number_of_alarms,
    CAST(NULLIF(number_of_floors_with_minimum_damage, '') AS INTEGER) AS number_of_floors_with_minimum_damage,
    CAST(NULLIF(number_of_floors_with_significant_damage, '') AS INTEGER) AS number_of_floors_with_significant_damage,
    CAST(NULLIF(number_of_floors_with_heavy_damage, '') AS INTEGER) AS number_of_floors_with_heavy_damage,
    CAST(NULLIF(incident_date, '') AS DATE) AS incident_date,
    CAST(NULLIF(alarm_dttm, '') AS TIMESTAMP) AS alarm_dttm,
    CAST(NULLIF(arrival_dttm, '') AS TIMESTAMP) AS arrival_dttm,
    CAST(NULLIF(close_dttm, '') AS TIMESTAMP) AS close_dttm,
    TRIM(NULLIF(district, '')) AS district,
    TRIM(NULLIF(city, '')) AS city,
    TRIM(NULLIF(zipcode, '')) AS zipcode,
    TRIM(NULLIF(battalion, '')) AS battalion,
    TRIM(NULLIF(station_area, '')) AS station_area,
     loaded_at
FROM {{ raw_table_ref }}
WHERE incident_date::date >= CURRENT_DATE - INTERVAL '7 days'
