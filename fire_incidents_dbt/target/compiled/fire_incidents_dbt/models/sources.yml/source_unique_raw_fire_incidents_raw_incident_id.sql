
    
    

select
    incident_id as unique_field,
    count(*) as n_records

from "fire_incidents"."raw"."fire_incidents_raw"
where incident_id is not null
group by incident_id
having count(*) > 1


