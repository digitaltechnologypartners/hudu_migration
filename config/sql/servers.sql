select
	archived
	,name
	,organization as company
	,manufacturer as make
    ,Location
	,serial_number as Serial
    ,primary_ip as ip
    ,model as model
    ,case when 
    	configuration_type in ("Virtual Machine","Vm") then true
    	else false end as isVM
    ,false as "isHypervisor"
    ,"" as "VM Host"
    ,configuration_status as status
FROM   
	configurations
where
	configuration_type in ("Server","Virtual Machine","Vm")