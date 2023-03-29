SELECT configurations.name AS 'Name',
	configurations.organization AS 'Company',
	configurations.location AS 'Location',
	configurations.model AS 'Model',
	CASE
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].name') LIKE '%LAN%'
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address')
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') NOT LIKE '%192.168.10_.%') OR (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') LIKE '%192.168.100.%')
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address')	
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].name') LIKE '%LAN%'
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address')
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') NOT LIKE '%192.168.10_.%') OR (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') LIKE '%192.168.100.%')
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address')
	END AS 'Local IP',
	'' AS 'License Key',
	CASE
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].name') LIKE '%NAT%'
			THEN TRUE
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') LIKE '%192.168.10_.%') AND (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') NOT LIKE '%192.168.100.%')
			THEN TRUE
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].name') LIKE '%NAT%'
			THEN TRUE
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') LIKE '%192.168.10_.%') AND (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') NOT LIKE '%192.168.100.%')
			THEN TRUE
		ELSE FALSE
	END AS 'Has Tunnel',
	CASE
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].name') LIKE '%NAT%'
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address')
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') LIKE '%192.168.10_.%') AND (JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address') NOT LIKE '%192.168.100.%')
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[0].ip_address')
		WHEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].name') LIKE '%NAT%'
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address')
		WHEN (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') LIKE '%192.168.10_.%') AND (JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address') NOT LIKE '%192.168.100.%')
			THEN JSON_EXTRACT(configurations.configuration_interfaces, '$[1].ip_address')
	END AS 'Natted IP'
FROM mdb.configurations
WHERE (configurations.name LIKE '%iDRAC%') OR (configurations.configuration_type LIKE '%iDRAC%');