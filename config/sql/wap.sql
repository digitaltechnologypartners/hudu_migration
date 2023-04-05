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
from configurations c
where configuration_type in ('WAP','Wifi','Access Point')