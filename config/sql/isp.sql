SELECT 
	archived,
	Provider AS name,
	`internet-wan`.organization AS company,
	`internet-wan`.`Location(s)` AS location,
	`internet-wan`.`Router/Firewall` AS cpe_device,
	'' AS cpe_ip,
	`internet-wan`.`Link Type` AS handoff,
	`internet-wan`.Provider AS vendor,
	`internet-wan`.`Account Number` AS account_number,
	'' AS device_access_codes,
	'' AS account_pin,	
	REGEXP_SUBSTR(REPLACE(`internet-wan`.`IP Address(es)`, 'Â', ''), '((Useable Static IP Address)*|(Sophos IP)|(IP~)|(GW)|(Range)|(Charter IP)|(IP Block)|(Static)|(IP Address)|(IP Range)|(Usable)|(Useable)|(Usable IP)|(WAN)|(Static IP)|(FW)|(IP)|(GW)|(Gateway))*( )*((:)|(~)|( )|(-))*( )*[0-9]{1,3}\\.{1}[0-9]{1,3}\\.{1}[0-9]{1,3}\\.{1}[0-9]{1,3}(./[0-9]{1,3})*') AS ip_addresses,
	`internet-wan`.`IP Address(es)` AS notes,
	'' AS interfaces
FROM 
	mdb.`internet-wan`
	
UNION ALL

SELECT
	archived,
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
	configurations.archived,
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