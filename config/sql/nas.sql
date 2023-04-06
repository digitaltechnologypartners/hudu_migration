select archived
	,configuration_status as status
	,name 
	,organization as company
	,location
	,manufacturer as make
	,model
	,serial_number as serial
	,primary_ip as IP
	,configuration_interfaces as interfaces
	,notes
	,'' as `use_case/description`
	,'' as capacity
from configurations
where configuration_type like 'NAS'