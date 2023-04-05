SELECT 'Office365 Tenant' AS name,
	organizations.name AS company,
	'Active' AS configuration_status,
	'No' AS archived,
	'false' AS has_security_defaults_enabled,
	'false' AS has_mfa_partially_deployed,
	'false' AS has_ip_restrictions_in_place,
	'false' AS user_has_admin_rights
FROM mdb.organizations
WHERE organizations.organization_type LIKE '%CSP Subscriber%'