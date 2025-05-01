{{
    config(
        materialized='incremental',
        schema='analytics',
        unique_key='incident_id',
        incremental_strategy='merge',
        merge_update_columns=[
            'call_number',
            'exposure_number',
            'suppression_units',
            'suppression_personnel',
            'ems_units',
            'ems_personnel',
            'other_units',
            'other_personnel',
            'estimated_property_loss',
            'estimated_contents_loss',
            'fire_fatalities',
            'fire_injuries',
            'civilian_fatalities',
            'civilian_injuries',
            'number_of_alarms',
            'number_of_floors_with_minimum_damage',
            'number_of_floors_with_significant_damage',
            'number_of_floors_with_heavy_damage',
            'time_period_id',
            'district_id',
            'battalion_id',
            'last_updated_at'
        ]
    )
}}

WITH stg_data AS (
    SELECT
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
        incident_date,
        alarm_dttm,
        arrival_dttm,
        close_dttm,
        district,
        city,
        zipcode,
        battalion,
        station_area,
        loaded_at
    FROM {{ ref('stg_fire_incidents') }}
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(last_updated_at) FROM {{ this }})
    {% endif %}
),

time_period AS (
    SELECT
        time_period_id,
        incident_date
    FROM {{ ref('dim_time_period') }}
),

district AS (
    SELECT
        district_id,
        district,
        city,
        zipcode
    FROM {{ ref('dim_district') }}
),

battalion AS (
    SELECT
        battalion_id,
        battalion,
        station_area
    FROM {{ ref('dim_battalion') }}
)

SELECT
    t.time_period_id,
    d.district_id,
    b.battalion_id,
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
    CURRENT_TIMESTAMP AS last_updated_at
FROM stg_data s
INNER JOIN time_period t
    ON s.incident_date = t.incident_date
INNER JOIN district d
    ON s.district = d.district
    AND s.city = d.city
    AND s.zipcode = d.zipcode
INNER JOIN battalion b
    ON s.battalion = b.battalion
    AND (s.station_area = b.station_area OR (s.station_area IS NULL AND b.station_area IS NULL))