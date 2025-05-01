select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    district_id as unique_field,
    count(*) as n_records

from "fire_incidents"."public_analytics"."dim_district"
where district_id is not null
group by district_id
having count(*) > 1



      
    ) dbt_internal_test