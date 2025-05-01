import requests
import pandas as pd
from datetime import datetime, timedelta
import time
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


def create_requests_session():
    session = requests.Session()
    retries = Retry(total=3, backoff_factor=1, status_forcelist=[429, 500, 502, 503, 504])
    session.mount('https://', HTTPAdapter(max_retries=retries))
    return session


def extract_data_from_api(api_url, start_date=None, limit=1000):
    all_data = []
    offset = 0
    session = create_requests_session()

    date_filter = f"incident_date >= '{start_date}'" if start_date else None
    where_clause = f"&$where={date_filter}" if date_filter else ""

    while True:
        paginated_url = f"{api_url}?$limit={limit}&$offset={offset}{where_clause}"
        try:
            response = session.get(paginated_url, timeout=10)
            response.raise_for_status()
            data = response.json()

            if not data:
                break

            all_data.extend(data)
            offset += limit
            print(f"Fetched {len(data)} records, total: {len(all_data)}")
            time.sleep(0.5)

        except requests.RequestException as e:
            print(f"Error fetching data at offset {offset}: {e}")
            break

    df = pd.DataFrame(all_data)

    if not df.empty:
        print(f"Extracted {len(df)} rows with {len(df.columns)} columns")

    return df