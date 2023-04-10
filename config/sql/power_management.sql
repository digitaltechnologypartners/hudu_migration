-- Active: 1680870568771@@172.19.1.10@3306@mdb
select
	archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make
	,serial_number as Serial
	,'' as "Vendor_info"
	,location	
    ,primary_ip as ip
	,'' as "Access URL"
    ,model as model
	,notes
FROM   
	configurations
where
	configuration_type in ("Managed Network UPS","Power Distribution Unit")