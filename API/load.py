import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

db_params = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'dbname': os.getenv('DB_NAME', 'fire_incidents'),
    'user': os.getenv('DB_USER', 'admin'),
    'password': os.getenv('DB_PASSWORD', 'securepassword')
}


def load_data(df, table_name):
    if df.empty:
        print("No data to load asdds")
        return

    engine = create_engine(
        f"postgresql://{db_params['user']}:{db_params['password']}@{db_params['host']}:{db_params['port']}/{db_params['dbname']}")

    # Create table with all columns as VARCHAR (except loaded_at)
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS raw.{table_name} (
        incident_id VARCHAR PRIMARY KEY,
        exposure_number VARCHAR,
        address VARCHAR,
        incident_date VARCHAR,
        call_number VARCHAR,
        alarm_dttm VARCHAR,
        arrival_dttm VARCHAR,
        close_dttm VARCHAR,
        city VARCHAR,
        zipcode VARCHAR,
        battalion VARCHAR,
        station_area VARCHAR,
        box VARCHAR,
        suppression_units VARCHAR,
        suppression_personnel VARCHAR,
        ems_units VARCHAR,
        ems_personnel VARCHAR,
        other_units VARCHAR,
        other_personnel VARCHAR,
        first_unit_on_scene VARCHAR,
        estimated_property_loss VARCHAR,
        estimated_contents_loss VARCHAR,
        fire_fatalities VARCHAR,
        fire_injuries VARCHAR,
        civilian_fatalities VARCHAR,
        civilian_injuries VARCHAR,
        number_of_alarms VARCHAR,
        primary_situation VARCHAR,
        mutual_aid VARCHAR,
        action_taken_primary VARCHAR,
        action_taken_secondary VARCHAR,
        action_taken_other VARCHAR,
        detector_alerted_occupants VARCHAR,
        property_use VARCHAR,
        area_of_fire_origin VARCHAR,
        ignition_cause VARCHAR,
        ignition_factor_primary VARCHAR,
        ignition_factor_secondary VARCHAR,
        heat_source VARCHAR,
        item_first_ignited VARCHAR,
        human_factors_associated_with_ignition VARCHAR,
        structure_type VARCHAR,
        structure_status VARCHAR,
        floor_of_fire_origin VARCHAR,
        fire_spread VARCHAR,
        no_flame_spread VARCHAR,
        number_of_floors_with_minimum_damage VARCHAR,
        number_of_floors_with_significant_damage VARCHAR,
        number_of_floors_with_heavy_damage VARCHAR,
        number_of_floors_with_extreme_damage VARCHAR,
        detectors_present VARCHAR,
        detector_type VARCHAR,
        detector_operation VARCHAR,
        detector_effectiveness VARCHAR,
        detector_failure_reason VARCHAR,
        automatic_extinguishing_system_present VARCHAR,
        automatic_extinguishing_system_type VARCHAR,
        automatic_extinguishing_system_performance VARCHAR,
        automatic_extinguishing_system_failure_reason VARCHAR,
        number_of_sprinkler_heads_operating VARCHAR,
        location VARCHAR,
        district VARCHAR,
        loaded_at TIMESTAMP
    );
    """
    with engine.connect() as conn:
        conn.execute(create_table_query)

    # Convert DataFrame to list of tuples to ensure proper type handling
    records = [tuple(row) for row in df.values]

    placeholders = ','.join(['%s'] * len(df.columns))
    update_clause = ', '.join([f"{col} = EXCLUDED.{col}" for col in df.columns if col != 'incident_id'])
    insert_query = f"""
    INSERT INTO raw.{table_name} ({','.join(df.columns)})
    VALUES ({placeholders})
    ON CONFLICT (incident_id) DO UPDATE
    SET {update_clause};
    """

    batch_size = 1000
    with engine.connect() as conn:
        cursor = conn.connection.cursor()
        for i in range(0, len(records), batch_size):
            batch = records[i:i + batch_size]
            cursor.executemany(insert_query, batch)
            conn.connection.commit()
        cursor.close()
