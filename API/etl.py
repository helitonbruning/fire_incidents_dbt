import os
from datetime import datetime, timedelta
from extract import extract_data_from_api
from transform import transform_data
from load import load_data
import logging

# Define the project root directory (two levels up from this file)
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
log_dir = os.path.join(project_root, 'logs')

# Ensure the logs directory exists
os.makedirs(log_dir, exist_ok=True)

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.join(log_dir, f"etl_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log")),
        logging.StreamHandler()
    ]
)


def main():
    api_url = 'https://data.sfgov.org/resource/wr8u-xric.json'
    start_date = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')

    logging.info("Starting ETL pipeline...")

    # Extract
    logging.info("Extracting data from API...")
    df = extract_data_from_api(api_url, start_date=start_date)

    if df.empty:
        logging.warning("No data fetched from API. Exiting pipeline.")
        return

    # Transform
    logging.info("Transforming data...")
    df = transform_data(df)


    # Load
    logging.info("Loading data into database...")
    load_data(df, 'fire_incidents_raw')


    logging.info("ETL pipeline completed.")


if __name__ == "__main__":
    main()