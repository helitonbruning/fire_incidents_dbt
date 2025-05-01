# Fire Incidents DBT Pipeline and API

## Project Overview
This project builds a data pipeline using DBT (Data Build Tool) to process fire incident data from the "Fire Incidents" dataset provided by DataSF (https://data.sfgov.org/Public-Safety/Fire-Incidents/wr8u-xric/about_data). The pipeline transforms raw data into a structured data warehouse model, consisting of a fact table (`fact_fire_incidents`) and dimension tables (`dim_time_period`, `dim_district`, `dim_battalion`). 

### Objectives
- Ingest raw fire incident data into a staging layer (`stg_fire_incidents`).
- Build a fact table (`fact_fire_incidents`) with granular incident details, linked to dimension tables.
- Create a summary view (`vw_fact_fire_incidents_summary`) for aggregated metrics.
- Allow loading of new fire incident data into the database using a JSON-based API endpoint.

## Project Structure
The project is organized as follows:
- **`etl.py`**: A Python script for Extract, Transform, Load (ETL) operations. This script extracts raw fire incident data from an external source (e.g., a CSV file or API), performs initial transformations (e.g., cleaning, renaming columns, and type conversion), and loads the data into the `raw.fire_incidents_raw` table in the PostgreSQL database for further processing by DBT.
- **`models/staging/stg_fire_incidents.sql`**: Staging model that ingests and cleans raw data from `raw.fire_incidents_raw`.
- **`models/fact_fire_incidents.sql`**: Fact table model that joins staged data with dimension tables.
- **`models/analytics/vw_fact_fire_incidents_summary.sql`**: View for aggregated metrics.

## Work Performed

### 1. Initial Setup and Fact Table Enhancement
- **Added `incident_id` to `fact_fire_incidents`**:
  - Modified `fact_fire_incidents.sql` to include `incident_id` as a granular identifier for each incident.
  - Changed the table from an aggregated structure (with `total_incidents`) to a row-per-incident structure.
  - Updated the `unique_key` to `incident_id` for incremental updates.
  - Created a new view (`vw_fact_fire_incidents_summary`) to retain aggregated metrics.

### 2. Added Numerical Columns to Fact Table
- **Incorporated All Numerical Columns from Dataset**:
  - Identified numerical columns from the DataSF dataset: `Incident Number`, `Exposure Number`, `Call Number`, `Suppression Units`, `Suppression Personnel`, `EMS Units`, `EMS Personnel`, `Other Units`, `Other Personnel`, `Estimated Property Loss`, `Estimated Contents Loss`, `Fire Fatalities`, `Fire Injuries`, `Civilian Fatalities`, `Civilian Injuries`, `Number of Alarms`, `Number of floors with minimum damage`, `Number of floors with significant damage`, `Number of floors with heavy damage`.
  - Updated `stg_fire_incidents.sql` to select these columns from `raw.fire_incidents_raw`, applying appropriate data type casting (e.g., `INTEGER` for counts, `NUMERIC` for monetary values).
  - Propagated these columns to `fact_fire_incidents.sql`.
  - Enhanced `vw_fact_fire_incidents_summary.sql` to include aggregated metrics (e.g., `total_suppression_personnel`, `avg_number_of_alarms`).

### 3. Fixed Database Error in `stg_fire_incidents.sql`
- **Issue**: A database error occurred because the column `suppression_personnel` was not found in `raw.fire_incidents_raw`.
- **Resolution**:
  - Discovered that the column name in the source table was `Suppression Personnel` (with a space), requiring quoted identifiers in SQL (`"Suppression Personnel"`).
  - Updated `stg_fire_incidents.sql` to quote all column names with spaces (e.g., `"Suppression Units"`, `"EMS Personnel"`).
  - Maintained consistent aliases (e.g., `suppression_personnel`) for downstream models.

## Setup Instructions

### Prerequisites
- **PostgreSQL**: A running PostgreSQL instance (`localhost:5432`, database `fire_incidents`, user `admin`).
- **DBT**: Installed and configured (`dbt-core` and `dbt-postgres`).
- **Python**: Python 3.8+ with the following packages:
  - `fastapi`
  - `psycopg2-binary`
  - `uvicorn`
  - `pydantic`
  Install them using:
  ```bash
  pip install fastapi psycopg2-binary uvicorn pydantic
  ```

### Installation
1. **Clone the Repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

   2. **Set Up the DBT Project**:
      - Navigate to the DBT project directory:
        ```bash
        cd ../fire_incidents_dbt/fire_incidents_dbt/dbt_project
        ```
      - Ensure the `profiles.yml` is configured to connect to the PostgreSQL database:
        ```yaml
        fire_incidents_dbt:
          target: dev
          outputs:
            dev:
              type: postgres
              host: localhost
              port: 5432
              user: admin
              password: ""  # Add password if required
              dbname: fire_incidents
              schema: public
        ```
      - OR Create a `.env` file in the root directory with the following content:
          ```yaml 
              DB_HOST=localhost
              DB_PORT=5432
              DB_NAME=fire_incidents
              DB_USER=admin
              DB_PASSWORD=securepassword
          ```

3. **Run the ETL Script**:
   Execute the Python script to fetch data from the API and load it into PostgreSQL:
   ```bash
   cd API
   python load_data.py
   ```
   
4. **Run the DBT Pipeline**:
   - Execute a full refresh to build the tables and views:
     ```bash
     dbt run --full-refresh
     ```
   - Verify the data:
     ```bash
     psql -h localhost -p 5432 -U admin -d fire_incidents
     SELECT * FROM analytics.fact_fire_incidents LIMIT 5;
     SELECT * FROM analytics.vw_fact_fire_incidents_summary LIMIT 5;
     ```

5. **Run Tests and Generate Documentation**:
   - Run DBT tests and freshness checks:
     ```bash
     dbt source freshness
     dbt test
     ```
   - Generate and serve DBT documentation:
     ```bash
     dbt docs generate
     dbt docs serve --port 8080
     ```
   - Access the documentation at `http://localhost:8080`.

## Usage
- **Query the Fact Table**: Use `fact_fire_incidents` for detailed incident analysis, including columns like `suppression_personnel`, `estimated_property_loss`, and `fire_fatalities`.
- **Analyze Aggregated Metrics**: Use `vw_fact_fire_incidents_summary` for summaries, such as `total_suppression_personnel` and `avg_number_of_alarms`.

## ETL Process
1. **Extraction**: The `load_data.py` script fetches data from the API using pagination (`$limit=1000`, `$offset`) and a date filter (last 7 days).
2. **Transformation**: Basic cleaning (e.g., date parsing, renaming `incident_number` to `incident_id`, null handling) is performed in Python. Deduplication is handled via `ON CONFLICT DO UPDATE` using `incident_id`.
3. **Loading**: Data is loaded into the `raw.fire_incidents_raw` table in PostgreSQL with a `loaded_at` timestamp.
4. **Data Quality**: The `data_quality.py` script checks for nulls, duplicates, and invalid dates before and after loading.
5. **DBT Transformation**: DBT transforms the raw data into a staging table (`stg_fire_incidents`) and creates an aggregated table (`fire_incidents_aggregated`) optimized for queries by **time period**, **district**, and **battalion**.
6. **Freshness Check**: DBT validates that the `loaded_at` column in `raw.fire_incidents_raw` is within 24 hours, ensuring daily updates.


## Deduplication Logic
- Deduplication is handled at the loading stage using `incident_id` as the primary key.
- The `ON CONFLICT DO UPDATE` clause in PostgreSQL updates existing records to reflect the latest data from the API.


## Freshness Validation
- The `sources.yml` defines freshness rules for `raw.fire_incidents_raw`:
  - Warns if the latest `loaded_at` is older than 24 hours.
  - Errors if older than 48 hours.
- Run `dbt source freshness` to validate daily updates.


## Troubleshooting
- **DBT Errors**:
  - If column names cause errors, verify the schema of `raw.fire_incidents_raw`:
    ```bash
    psql -h localhost -p 5432 -U admin -d fire_incidents
    \d raw.fire_incidents_raw;
    ```
  - Adjust column names in `stg_fire_incidents.sql` to match the source table (e.g., use `"Suppression Personnel"` for columns with spaces).
