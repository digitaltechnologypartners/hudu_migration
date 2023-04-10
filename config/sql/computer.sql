-- Active: 1680870568771@@172.19.1.10@3306@mdb
select
	archived
	,configuration_status as status
	,name
	,organization as company
	,manufacturer as make
    ,location
	,case when (name like '%laptop%' or configuration_type like 'Laptop') then true else false end as islaptop
	,serial_number as Serial
    ,primary_ip as ip
    ,model as model
    ,'' as isVM
    ,'' as "VM Host"
	,configuration_interfaces as interfaces
	,notes
	,id as glue_id
FROM   
	configurations
where
	configuration_type in ("workstation","laptop")