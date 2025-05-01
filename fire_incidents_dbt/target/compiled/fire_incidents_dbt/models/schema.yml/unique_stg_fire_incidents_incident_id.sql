
    
    

select
    incident_id as unique_field,
    count(*) as n_records

from "fire_incidents"."public_staging"."stg_fire_incidents"
where incident_id is not null
group by incident_id
having count(*) > 1


