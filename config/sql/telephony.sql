SELECT                                                      
	archived                                                 
	,configuration_status AS status                          
	,name                                                    
	,organization AS company                                 
	,location                                                
	,primary_ip AS ip                                        
	,serial_number AS serial                                 
	,'' AS role                                              
	,configuration_type AS type                              
	,'' AS handset_type                                      
	,'' AS connectivity_method
	,configuration_interfaces as interfaces         
	,notes
	,id as glue_id
FROM configurations                                         
WHERE configuration_type IN ("PBX","Telephone","3CX Server")