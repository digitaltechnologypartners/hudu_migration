select
	archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make
    ,location
	,serial_number as Serial
    ,primary_ip as ip
    ,model as model
    ,case when 
    	configuration_type in ("Virtual Machine","Vm") then true
    	else false end as isVM
    ,case 
	    when name like '%VM Host%' or name like '%HyperV%' then true
		else false 
	end as "isHypervisor"
    ,"" as "VM Host"
	,configuration_interfaces as interfaces
FROM   
	configurations
where
	configuration_type in ("Server","Virtual Machine","Vm")