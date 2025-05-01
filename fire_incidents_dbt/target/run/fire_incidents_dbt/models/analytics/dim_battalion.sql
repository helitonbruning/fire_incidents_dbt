
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "fire_incidents"."public_analytics"."dim_battalion" as DBT_INTERNAL_DEST
        using "dim_battalion__dbt_tmp155045934361" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.battalion_id = DBT_INTERNAL_DEST.battalion_id))

    
    when matched then update set
        "battalion_id" = DBT_INTERNAL_SOURCE."battalion_id","battalion" = DBT_INTERNAL_SOURCE."battalion","station_area" = DBT_INTERNAL_SOURCE."station_area","last_updated_at" = DBT_INTERNAL_SOURCE."last_updated_at"
    

    when not matched then insert
        ("battalion_id", "battalion", "station_area", "last_updated_at")
    values
        ("battalion_id", "battalion", "station_area", "last_updated_at")


  