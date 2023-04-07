SELECT 
	archived
	,configuration_status AS status
	,ORGANIZATION AS company
	,location
	,name
	,manufacturer AS make
	,model
	,primary_ip AS ip
	,serial_number AS serial
	,'false' AS is_remotely_accessed
	,case
		when NAME LIKE '%Hikvision%' 
			then TRUE
		when manufacturer LIKE '%Hikvision%' OR manufacturer LIKE '%HKVision%'
			then TRUE
	END AS isHikvision
	,'false' AS has_hikconnect_configured
	,configuration_interfaces AS interfaces
	,notes
FROM
	configurations
WHERE
	configuration_type IN ("DVR Camera System","Surveillance NVR","Surveillance DVR")