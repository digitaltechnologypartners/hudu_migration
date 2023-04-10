-- Active: 1680870568771@@172.19.1.10@3306@mdb
select
	archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make
	,hostname
    ,mac_address as "Mac Address"
	,serial_number as Serial
	,location	
    ,primary_ip as ip
    ,model as model
	,configuration_interfaces as interfaces
	,notes
	,id as glue_id
FROM   
	configurations
where
	configuration_type in ("Other")