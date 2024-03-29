select archived 
	,name
	,organization as company
	,configuration_status as status
	,manufacturer as make
	,model
	,location
	,serial_number as serial
	,primary_ip as IP
	,position as specific_location_in_office
	,configuration_interfaces as interfaces
	,notes
	,id as glue_id
from configurations c
where configuration_type in ('WAP','Wifi','Access Point')