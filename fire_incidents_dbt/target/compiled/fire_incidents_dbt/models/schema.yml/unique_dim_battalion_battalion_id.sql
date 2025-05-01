
    
    

select
    battalion_id as unique_field,
    count(*) as n_records

from "fire_incidents"."public_analytics"."dim_battalion"
where battalion_id is not null
group by battalion_id
having count(*) > 1


