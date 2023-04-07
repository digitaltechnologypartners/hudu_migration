SELECT 
	`internet-wan`.Provider AS name,
	`internet-wan`.organization AS company,
	`internet-wan`.`Location(s)` AS location,
	`internet-wan`.`Router/Firewall` AS cpe_device,
	'' AS cpe_ip,
	`internet-wan`.`Link Type` AS handoff,
	`internet-wan`.Provider AS vendor,
	`internet-wan`.`Account Number` AS account_number,
	'' AS device_access_codes,
	'' AS account_pin,	
	`internet-wan`.`IP Address(es)` AS ip_addresses,
	'' AS notes,
	'' AS interfaces
FROM 
	mdb.`internet-wan`
	
UNION ALL

SELECT
	vendors.`Vendor Name` AS NAME,
	vendors.organization AS company,
	'' AS location,
	'' AS cpe_device,
	'' AS cpe_ip,
	'' AS handoff,
	vendors.`Vendor Name` AS vendor,
	vendors.`Account Number` AS account_number,
	'' AS device_access_code,
	'' AS account_pin,	
	'' AS ip_addresses,
	vendors.Representative AS notes,
	'' AS interfaces
	
FROM 
	mdb.vendors
	
UNION ALL

SELECT 
	configurations.name,
	configurations.organization AS company,
	configurations.location,
	configurations.configuration_type AS cpe_device,
	configurations.primary_ip AS cpe_ip,
	'' AS handoff,
	configurations.manufacturer AS vendor,
	'' AS account_number,
	'' AS device_access_codes,
	''	AS account_pin,
	configurations.primary_ip AS ip_addresses,
	configurations.notes,
	configurations.configuration_interfaces AS interfaces
	
FROM mdb.configurations
WHERE configurations.configuration_type LIKE '%Internet Modem%';