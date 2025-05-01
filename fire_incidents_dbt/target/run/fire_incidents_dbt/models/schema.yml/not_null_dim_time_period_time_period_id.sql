select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select time_period_id
from "fire_incidents"."public_analytics"."dim_time_period"
where time_period_id is null



      
    ) dbt_internal_test