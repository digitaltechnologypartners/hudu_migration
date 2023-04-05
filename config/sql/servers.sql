select
	archived
	,configuration_status as status
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
    ,case when (
		name is like '%VM Host' then true
		or name is like '%HyperV%' then true
		)
	else false end as "isHypervisor"
    ,"" as "VM Host"
FROM   
	configurations
where
	configuration_type in ("Server","Virtual Machine","Vm")