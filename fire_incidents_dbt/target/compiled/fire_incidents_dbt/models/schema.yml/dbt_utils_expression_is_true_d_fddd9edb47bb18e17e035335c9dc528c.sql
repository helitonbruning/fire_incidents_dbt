



select
    1
from "fire_incidents"."public_analytics"."dim_time_period"

where not(last_updated_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours')

