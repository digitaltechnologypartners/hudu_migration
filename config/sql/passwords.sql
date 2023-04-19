select p.organization as company
	,case 
		when resource_type in ('StructuredData::Row','Configuration') 
			or p.name like '%365%' 
			or username like '%onmicrosoft.com%'
			then 'Asset' 
		else null end as passwordable_type
	,resource_id as glue_id
	,p.name as name
	,password
	,url 
	,username 
	,password_category as password_type
	,p.notes as description
from passwords p
where (resource_type not like 'StructuredData::Cell'
	or resource_type is null)
