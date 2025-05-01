
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "fire_incidents"."public_analytics"."dim_time_period" as DBT_INTERNAL_DEST
        using "dim_time_period__dbt_tmp155046034354" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.incident_date = DBT_INTERNAL_DEST.incident_date))

    
    when matched then update set
        "time_period_id" = DBT_INTERNAL_SOURCE."time_period_id","incident_date" = DBT_INTERNAL_SOURCE."incident_date","incident_year" = DBT_INTERNAL_SOURCE."incident_year","incident_month" = DBT_INTERNAL_SOURCE."incident_month","incident_quarter" = DBT_INTERNAL_SOURCE."incident_quarter","last_updated_at" = DBT_INTERNAL_SOURCE."last_updated_at"
    

    when not matched then insert
        ("time_period_id", "incident_date", "incident_year", "incident_month", "incident_quarter", "last_updated_at")
    values
        ("time_period_id", "incident_date", "incident_year", "incident_month", "incident_quarter", "last_updated_at")


  