
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "fire_incidents"."public_analytics"."fact_fire_incidents" as DBT_INTERNAL_DEST
        using "fact_fire_incidents__dbt_tmp155046083805" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.incident_id = DBT_INTERNAL_DEST.incident_id))

    
    when matched then update set
        "time_period_id" = DBT_INTERNAL_SOURCE."time_period_id","district_id" = DBT_INTERNAL_SOURCE."district_id","battalion_id" = DBT_INTERNAL_SOURCE."battalion_id","incident_id" = DBT_INTERNAL_SOURCE."incident_id","call_number" = DBT_INTERNAL_SOURCE."call_number","exposure_number" = DBT_INTERNAL_SOURCE."exposure_number","suppression_units" = DBT_INTERNAL_SOURCE."suppression_units","suppression_personnel" = DBT_INTERNAL_SOURCE."suppression_personnel","ems_units" = DBT_INTERNAL_SOURCE."ems_units","ems_personnel" = DBT_INTERNAL_SOURCE."ems_personnel","other_units" = DBT_INTERNAL_SOURCE."other_units","other_personnel" = DBT_INTERNAL_SOURCE."other_personnel","estimated_property_loss" = DBT_INTERNAL_SOURCE."estimated_property_loss","estimated_contents_loss" = DBT_INTERNAL_SOURCE."estimated_contents_loss","fire_fatalities" = DBT_INTERNAL_SOURCE."fire_fatalities","fire_injuries" = DBT_INTERNAL_SOURCE."fire_injuries","civilian_fatalities" = DBT_INTERNAL_SOURCE."civilian_fatalities","civilian_injuries" = DBT_INTERNAL_SOURCE."civilian_injuries","number_of_alarms" = DBT_INTERNAL_SOURCE."number_of_alarms","number_of_floors_with_minimum_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_minimum_damage","number_of_floors_with_significant_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_significant_damage","number_of_floors_with_heavy_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_heavy_damage","last_updated_at" = DBT_INTERNAL_SOURCE."last_updated_at"
    

    when not matched then insert
        ("time_period_id", "district_id", "battalion_id", "incident_id", "call_number", "exposure_number", "suppression_units", "suppression_personnel", "ems_units", "ems_personnel", "other_units", "other_personnel", "estimated_property_loss", "estimated_contents_loss", "fire_fatalities", "fire_injuries", "civilian_fatalities", "civilian_injuries", "number_of_alarms", "number_of_floors_with_minimum_damage", "number_of_floors_with_significant_damage", "number_of_floors_with_heavy_damage", "last_updated_at")
    values
        ("time_period_id", "district_id", "battalion_id", "incident_id", "call_number", "exposure_number", "suppression_units", "suppression_personnel", "ems_units", "ems_personnel", "other_units", "other_personnel", "estimated_property_loss", "estimated_contents_loss", "fire_fatalities", "fire_injuries", "civilian_fatalities", "civilian_injuries", "number_of_alarms", "number_of_floors_with_minimum_damage", "number_of_floors_with_significant_damage", "number_of_floors_with_heavy_damage", "last_updated_at")


  