-- Active: 1680870568771@@172.19.1.10@3306@mdb
select
	archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make_os
    ,location
	,serial_number as Serial
    ,primary_ip as ip
    ,model as model
    ,false as "isVM"
    ,false as "is x86"
	,"" as "VM Host"
	,configuration_interfaces as interfaces
	,notes
FROM   
	configurations
where
	configuration_type in ("Firewall","Router")