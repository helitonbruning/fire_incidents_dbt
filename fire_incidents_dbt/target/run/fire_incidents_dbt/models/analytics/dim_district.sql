
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "fire_incidents"."public_analytics"."dim_district" as DBT_INTERNAL_DEST
        using "dim_district__dbt_tmp155045984811" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.district_id = DBT_INTERNAL_DEST.district_id))

    
    when matched then update set
        "district_id" = DBT_INTERNAL_SOURCE."district_id","district" = DBT_INTERNAL_SOURCE."district","city" = DBT_INTERNAL_SOURCE."city","zipcode" = DBT_INTERNAL_SOURCE."zipcode","last_updated_at" = DBT_INTERNAL_SOURCE."last_updated_at"
    

    when not matched then insert
        ("district_id", "district", "city", "zipcode", "last_updated_at")
    values
        ("district_id", "district", "city", "zipcode", "last_updated_at")


  