-- Schema that should be returned:
-- name
-- ,organization_type
-- ,organization_status
-- ,short_name
-- ,quick_notes            **** Glue Only
-- ,alert                  **** Glue Only
-- ,primary_location_name
-- ,address_1
-- ,address_2
-- ,city
-- ,region
-- ,country
-- ,postal_code
-- ,phone
-- ,fax
-- ,website                **** Manage Only

-- Glue query
select orgs.name as name
    ,organization_type
    ,organization_status
    ,short_name
    ,quick_notes
    ,alert
    ,locs.name as primary_location_name
    ,address_1
    ,address_2
    ,city
    ,region
    ,country
    ,postal_code
    ,phone
    ,fax
from organizations orgs 
    left join locations locs on orgs.name = locs.organization and locs.primary = 1

-- Manage query
-- SELECT com.Company_Name AS name
--     ,com.Company_Type_Desc AS organization_type
--     ,com.Company_Status_Desc AS organization_status
--     ,com.Company_ID AS short_name
--     ,adr.Site_Name AS primary_location_name
--     ,adr.Address_Line1 AS address_1
--     ,adr.Address_Line2 AS address_2
--     ,adr.City AS city
--     ,adr.State_ID AS region
--     ,adr.Country AS country
--     ,adr.Zip AS postal_code
--     ,adr.PhoneNbr AS phone
--     ,adr.PhoneNbr_Fax AS fax
--     ,com.Website_URL AS website
-- FROM v_rpt_Company com
--     LEFT JOIN v_rpt_CompanyAddress adr ON com.Company_RecID = adr.Company_RecID AND adr.Default_Flag = 1