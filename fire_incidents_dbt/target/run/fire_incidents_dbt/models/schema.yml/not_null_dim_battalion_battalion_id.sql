select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select battalion_id
from "fire_incidents"."public_analytics"."dim_battalion"
where battalion_id is null



      
    ) dbt_internal_test