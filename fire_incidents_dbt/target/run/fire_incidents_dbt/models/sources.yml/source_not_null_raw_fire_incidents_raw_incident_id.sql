select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select incident_id
from "fire_incidents"."raw"."fire_incidents_raw"
where incident_id is null



      
    ) dbt_internal_test