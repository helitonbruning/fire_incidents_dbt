
    
    

select
    time_period_id as unique_field,
    count(*) as n_records

from "fire_incidents"."public_analytics"."dim_time_period"
where time_period_id is not null
group by time_period_id
having count(*) > 1


