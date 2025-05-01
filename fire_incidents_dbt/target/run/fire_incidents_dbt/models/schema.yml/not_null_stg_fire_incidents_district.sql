select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select district
from "fire_incidents"."public_staging"."stg_fire_incidents"
where district is null



      
    ) dbt_internal_test