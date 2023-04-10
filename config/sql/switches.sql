SELECT
	archived
	,configuration_status AS status
	,name
	,organization AS company
	,location
	,serial_number AS serial
	,primary_ip AS ip
	,manufacturer AS make
	,model
	,CASE
		when NAME LIKE '%managed%'
			then true
		when configuration_type LIKE '%Managed Network Switch%'
			then true
	END AS isManaged
	,configuration_interfaces as interfaces
	,notes
	,id as glue_id
FROM
	configurations
WHERE
	configuration_type IN ("switch","Managed Network Switch")