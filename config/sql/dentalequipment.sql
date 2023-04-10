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
	notes,
    configuration_interfaces as interfaces,
	id as glue_id
FROM mdb.configurations
WHERE configurations.configuration_type LIKE '%Dental%';