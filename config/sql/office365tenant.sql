SELECT 'Office365 Tenant' AS name,
	organizations.name AS company,
	'Active' AS configuration_status,
	FALSE AS archived,
	FALSE AS has_security_defaults_enabled,
	FALSE AS has_mfa_partially_deployed,
	FALSE AS has_ip_restrictions_in_place,
	FALSE AS user_has_admin_rights
FROM mdb.organizations
WHERE organizations.organization_type LIKE '%CSP Subscriber';