select company
	,MAX(name) as name
	,Street_Address
	,city 
	,State
	,Zip
	,Primary_Phone
from (
	select organization as company
		,name
		,case
			when address_1 is not null and address_2 is not null then CONCAT(address_1, ', ', address_2)
			when address_1 is not null and address_2 is null then address_1 
			when address_1 is null and address_2 is not null then address_2 
			when address_1 is null and address_2 is null then 'No Street Address Listed'
			end as Street_Address
		,city as City 
		,region as State
		,postal_code as Zip
		,phone as Primary_Phone
	from locations
) as location
group by Street_Address