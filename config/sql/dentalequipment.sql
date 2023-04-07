SELECT
	name,
	organization AS company,
	location,
	archived,
	configuration_status,
	configuration_type AS type,
	primary_ip AS ip_address,
	manufacturer AS make,
	model,
	serial_number,
	'' AS vendor_info,
	CONCAT(notes, '\n', configuration_interfaces) AS notes
	
	
FROM mdb.configurations
WHERE configurations.configuration_type LIKE '%Dental%';