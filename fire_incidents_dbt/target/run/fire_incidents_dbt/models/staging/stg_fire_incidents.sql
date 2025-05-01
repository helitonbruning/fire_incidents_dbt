
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "fire_incidents"."public_staging"."stg_fire_incidents" as DBT_INTERNAL_DEST
        using "stg_fire_incidents__dbt_tmp155045808896" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.incident_id = DBT_INTERNAL_DEST.incident_id))

    
    when matched then update set
        "incident_id" = DBT_INTERNAL_SOURCE."incident_id","call_number" = DBT_INTERNAL_SOURCE."call_number","exposure_number" = DBT_INTERNAL_SOURCE."exposure_number","suppression_units" = DBT_INTERNAL_SOURCE."suppression_units","suppression_personnel" = DBT_INTERNAL_SOURCE."suppression_personnel","ems_units" = DBT_INTERNAL_SOURCE."ems_units","ems_personnel" = DBT_INTERNAL_SOURCE."ems_personnel","other_units" = DBT_INTERNAL_SOURCE."other_units","other_personnel" = DBT_INTERNAL_SOURCE."other_personnel","estimated_property_loss" = DBT_INTERNAL_SOURCE."estimated_property_loss","estimated_contents_loss" = DBT_INTERNAL_SOURCE."estimated_contents_loss","fire_fatalities" = DBT_INTERNAL_SOURCE."fire_fatalities","fire_injuries" = DBT_INTERNAL_SOURCE."fire_injuries","civilian_fatalities" = DBT_INTERNAL_SOURCE."civilian_fatalities","civilian_injuries" = DBT_INTERNAL_SOURCE."civilian_injuries","number_of_alarms" = DBT_INTERNAL_SOURCE."number_of_alarms","number_of_floors_with_minimum_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_minimum_damage","number_of_floors_with_significant_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_significant_damage","number_of_floors_with_heavy_damage" = DBT_INTERNAL_SOURCE."number_of_floors_with_heavy_damage","incident_date" = DBT_INTERNAL_SOURCE."incident_date","alarm_dttm" = DBT_INTERNAL_SOURCE."alarm_dttm","arrival_dttm" = DBT_INTERNAL_SOURCE."arrival_dttm","close_dttm" = DBT_INTERNAL_SOURCE."close_dttm","district" = DBT_INTERNAL_SOURCE."district","city" = DBT_INTERNAL_SOURCE."city","zipcode" = DBT_INTERNAL_SOURCE."zipcode","battalion" = DBT_INTERNAL_SOURCE."battalion","station_area" = DBT_INTERNAL_SOURCE."station_area","loaded_at" = DBT_INTERNAL_SOURCE."loaded_at"
    

    when not matched then insert
        ("incident_id", "call_number", "exposure_number", "suppression_units", "suppression_personnel", "ems_units", "ems_personnel", "other_units", "other_personnel", "estimated_property_loss", "estimated_contents_loss", "fire_fatalities", "fire_injuries", "civilian_fatalities", "civilian_injuries", "number_of_alarms", "number_of_floors_with_minimum_damage", "number_of_floors_with_significant_damage", "number_of_floors_with_heavy_damage", "incident_date", "alarm_dttm", "arrival_dttm", "close_dttm", "district", "city", "zipcode", "battalion", "station_area", "loaded_at")
    values
        ("incident_id", "call_number", "exposure_number", "suppression_units", "suppression_personnel", "ems_units", "ems_personnel", "other_units", "other_personnel", "estimated_property_loss", "estimated_contents_loss", "fire_fatalities", "fire_injuries", "civilian_fatalities", "civilian_injuries", "number_of_alarms", "number_of_floors_with_minimum_damage", "number_of_floors_with_significant_damage", "number_of_floors_with_heavy_damage", "incident_date", "alarm_dttm", "arrival_dttm", "close_dttm", "district", "city", "zipcode", "battalion", "station_area", "loaded_at")


  