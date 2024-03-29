select archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make
	,model
	,location
	,serial_number as serial
	,primary_ip as IP
	,'false' as isManagedbyPrinterCompany
    ,configuration_interfaces as interfaces
	,notes
	,id as glue_id
from configurations conf
where configuration_type in ('Printer','Scanner','FAX')