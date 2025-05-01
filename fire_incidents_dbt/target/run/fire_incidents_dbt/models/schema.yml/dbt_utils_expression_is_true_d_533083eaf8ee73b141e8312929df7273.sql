select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      



select
    1
from "fire_incidents"."public_analytics"."dim_district"

where not(last_updated_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours')


      
    ) dbt_internal_test