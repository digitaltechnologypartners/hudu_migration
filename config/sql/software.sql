select archived 
	,organization as company
	,'Active' as status
	,name 
	,Version as version
	,Manufacturer as vendor
	,null as type
	,'false' as isLegacy
	,`License Key(s)` as license_key
	,Location as location
	,`Additional Notes` as notes 
	,null as linked_server
	,null as linked_workstation
	,null as business_use_case
	,null as sql_instance
	,null as backup_information
from licensing
union all
select archived 
	,organization as company
	,'Active' as status
	,Name as name
	,Version as version
	,License as vendor
	,null as type
	,case 
		when `Legacy?` like 'No' then 'false'
		when `Legacy?` like 'Yes' then 'true'
	end as isLegacy
	,null as license_key
	,null as location
	,null as notes
	,null as linked_server
	,null as linked_workstation
	,null as business_use_case
	,null as sql_instance
	,null as backup_information
from `pm-imaging-software`
union all
select archived
	,organization as company
	,'Active' as status
	,Name as name
	,Version as version
	,Vendor as vendor
	,Category as type
	,'false' as isLegacy
	,null as license_key
	,null as location
	,null as notes
	,null as linked_server
	,null as linked_workstation
	,null as business_use_case
	,null as sql_instance
	,null as backup_information
from applications