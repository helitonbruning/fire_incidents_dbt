select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select district
from "fire_incidents"."raw"."fire_incidents_raw"
where district is null



      
    ) dbt_internal_test