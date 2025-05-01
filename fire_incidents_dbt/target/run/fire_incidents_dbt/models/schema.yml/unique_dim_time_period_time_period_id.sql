select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    time_period_id as unique_field,
    count(*) as n_records

from "fire_incidents"."public_analytics"."dim_time_period"
where time_period_id is not null
group by time_period_id
having count(*) > 1



      
    ) dbt_internal_test