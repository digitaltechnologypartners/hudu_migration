SELECT 
	archived
	,configuration_status AS status
	,ORGANIZATION AS company
	,location
	,name
    ,manufacturer as make
    ,model
	,'' AS playback_device
	,'' AS amp_type
	,'' AS speaker_type
	,'' AS volume_control_type
	,configuration_interfaces AS interfaces
	,notes
FROM 
	configurations
WHERE
	configuration_type IN ("Sonos")