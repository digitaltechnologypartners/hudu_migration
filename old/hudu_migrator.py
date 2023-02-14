import pandas as pd
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
import requests
import json
import logging
import copy

from ratelimit import limits, RateLimitException, sleep_and_retry

ONE_MINUTE = 60
MAX_CALLS_PER_MINUTE = 300

logger = logging.getLogger(__name__)
logging.basicConfig(filename='migrator.log', filemode='a', level=logging.INFO, \
    format='%(asctime)s : %(levelname)s : %(message)s ', datefmt='%m/%d/%Y %I:%M:%S %p')

load_dotenv()

GLUE_DB_CON_STR = os.getenv('GLUE_DB_CON_STR')
GLUE_EXPT_PATH = os.getenv('GLUE_EXPT_PATH')
MANG_DB_CON_STR = os.getenv('MANG_DB_CON_STR')
API_KEY = os.getenv('API_KEY')
BASE_URL = os.getenv('BASE_URL')

headers = {
    'x-api-key':API_KEY,
}

def getExportDB():
    engine = create_engine(GLUE_DB_CON_STR)
    con = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
    return con

def getManageDB():
    engine = create_engine(MANG_DB_CON_STR)
    con = engine.connect()
    return con

def loadExpDb():
    for file in os.listdir(GLUE_EXPT_PATH):
        if file.endswith(".csv"):
            df = pd.read_csv(open(GLUE_EXPT_PATH + '/' + file))
            tablename = os.path.splitext(file)[0]
            connection = getExportDB()
            df.to_sql(tablename,con=connection,if_exists='replace',index=False)
            print(file + ' OK')

# def getExistingRecords(endpoint, namesonly=False):
    # endpointpage = endpoint + '?page='
    # records = []
    # recordsResultsCount = 25
    # pagenum = 1
    # while recordsResultsCount == 25:
    #     url = BASE_URL + endpointpage + str(pagenum)
    #     r = requests.get(url,headers=headers)
    #     if r.status_code == 200:
    #         existing_records = r.json()[endpoint]
    #         pagenum += 1
    #         recordsResultsCount = len(existing_records)
    #         for record in existing_records:
    #             if namesonly == True:
    #                 records.append(record['name'])
    #             else:
    #                 records.append(record)
    #     else:
    #         print('Got an error while getting records for ' + endpoint + ': ' + str(r.status_code) + ' ' + r.reason)
    #         logging.error('Got an error while getting records for ' + endpoint + ': ' + str(r.status_code) + ' ' + r.reason + '\n' + json.dumps(r.json(), indent=4))
    #         break
    # return records

# def parseLayouts(layouts):
#     parsedLayouts = []

#     commonFields = layouts["common_fields"]
#     assetLayouts = layouts["asset_layouts"]

#     for assetLayout in assetLayouts:
#         assetLayout["color"] = "#000000"
#         assetLayout["icon_color"] = "#FFFFFF"
#         assetLayout["active"] = True

#         for field in assetLayout["common_fields"]:
#             for commonField in commonFields:
#                 if field == commonField["label"]:
#                     assetLayout["fields"].append(commonField)

#         assetLayout.pop("common_fields")
        
#         position = 1
#         for layoutField in assetLayout['fields']:
#             layoutField["position"] = position
#             position += 1

#         parsedLayouts.append(assetLayout)

#     return parsedLayouts

# def getLayoutLinkRefs(layout, field):
#     existingLayouts = getExistingRecords('asset_layouts')
#     for existingLayout in existingLayouts:
#         if existingLayout['name'] == field['linkable_id']:
#             layout['fields'][layout['fields'].index(field)]['linkable_id'] = existingLayout['id']
#     return layout

# def createlayouts():
#     endpoint = 'asset_layouts'
#     url = os.path.join(BASE_URL, endpoint)

#     file = open('asset_layouts2.json')
#     layoutsjson = json.load(file)
#     layouts = parseLayouts(layoutsjson)
#     selfrefs = []
#     for layout in layouts:
#         existingLayouts = getExistingRecords(endpoint, namesonly=True)
#         if layout['name'] not in existingLayouts:
#             fields = layout['fields']
#             for field in fields:
#                 if field['field_type'] == 'AssetTag':
#                     if layout['name'] == field['linkable_id']:
#                         layout['fields'].remove(field)
#                         selfref = copy.deepcopy(layout)
#                         selfref['fields'].clear()
#                         selfref['fields'].append(field)
#                         selfrefs.append(selfref)
#                     else:
#                         layout = getLayoutLinkRefs(layout, field)
#             data = {
#                 "asset_layout": layout
#             }
#             r = requests.post(url, headers=headers, json=data)
#             print(layout['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
#             if r.status_code != 200:
#                 logging.error('asset_layout: ' + layout['name'] + ' creation failed: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + json.dumps(r.json(), indent=4))
#             else:
#                 logging.info('asset_layout: ' + layout['name'] + ' creation info: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4))
#         else:
#             print(layout['name'] + ' already exists.')
#             logging.warning('asset_layout: ' + layout['name'] + 'already exists. No http request was made.')
#     if len(selfrefs) > 0:
#         existingLayouts = getExistingRecords(endpoint)
#         for selfref in selfrefs:
#             id = 0
#             for afield in selfref['fields']:
#                 if afield['field_type'] == 'AssetTag':
#                     if isinstance(afield['linkable_id'], str):
#                         selfref = getLayoutLinkRefs(selfref, afield)
#             for existingLayout in existingLayouts:
#                 if existingLayout['name'] == selfref['name']:
#                     id = existingLayout['id']
#             url = BASE_URL + endpoint + '/' + str(id)
#             data = {
#                 "asset_layout": selfref
#             }
#             r = requests.put(url, headers=headers, json=data)
#             print(selfref['name'] + ' update status: ' + str(r.status_code) + ': ' + r.reason)
#             if r.status_code != 200:
#                 logging.error('asset_layout: ' + selfref['name'] + ' update failed: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + json.dumps(r.json(), indent=4))
#             else:
#                 logging.info('asset_layout: ' + selfref['name'] + ' update info: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4))

def getCompaniesJson(source = ""):
    if source == 'glue':
        query = text("""select orgs.name as name
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
                ,locs.notes as location_notes
            from organizations orgs 
                left join locations locs on orgs.name = locs.organization and locs.primary = 1""")
        connection = getExportDB()
    elif source == 'manage':
        query = text("""SELECT com.Company_Name AS name
                ,com.Company_Type_Desc AS organization_type
                ,com.Company_Status_Desc AS organization_status
                ,com.Company_ID AS short_name
                ,adr.Site_Name AS primary_location_name
                ,adr.Address_Line1 AS address_1
                ,adr.Address_Line2 AS address_2
                ,adr.City AS city
                ,adr.State_ID AS region
                ,adr.Country AS country
                ,adr.Zip AS postal_code
                ,adr.PhoneNbr AS phone
                ,adr.PhoneNbr_Fax AS fax
                ,com.Website_URL AS website
            FROM v_rpt_Company com
                LEFT JOIN v_rpt_CompanyAddress adr ON com.Company_RecID = adr.Company_RecID AND adr.Default_Flag = 1""")
        connection = getManageDB()
    
    organizations = pd.read_sql(query,con=connection)
    if source == 'manage':
        glueQnaQuery = text("""select orgs.name as name
                ,quick_notes 
                ,alert
            from organizations orgs""")
        glueQna = pd.read_sql(glueQnaQuery,con=getExportDB())
        organizations = pd.merge(organizations, glueQna, on="name", how="left")


    organizations = organizations.to_json(orient = 'records')
    organizations = json.loads(organizations)
    return organizations

def chkTypeBlackList(org):
    keep = True
    typeBlackList = ["Competitor","Demo Company","Former Client","Former Client - Bought by other DTP Customer","Not-a-fit","Partner","Prospect","Site Billing Company","Subcontractor","Vendor"]
    companyTypes = org['organization_type'].split(', ')
    for companyType in companyTypes:
        if companyType in typeBlackList:
            keep = False
    return keep

def rmNonClients(organizations):
    orgs = [org for org in organizations if chkTypeBlackList(org)]
    return orgs

def parseCompaniesJson(organizations):
    companies = []

    for org in organizations:
        company = {}
        company['name'] = org['name']
        company['company_type'] = org['organization_type']
        company['id_number'] = org['short_name']
        company['address_line_1'] = org['address_1']
        company['address_line_2'] = org['address_2']
        company['city'] = org['city']
        company['state'] = org['region']
        company['zip'] = org['postal_code']
        company['country_name'] = org['country']
        company['phone_number'] = org['phone']
        company['fax_number'] = org['fax']
        if org['website']:
            company['website'] = org['website']
        if org["alert"] is not None:
            if org['quick_notes'] is not None:
                company['notes'] = '<h3 style="color:#b22222">ALERT: ' + org['alert'] + '</h3><br><br>' + org['quick_notes']
            else:
                company['notes'] = '<h3 style="color:#b22222">ALERT: ' + org['alert'] + '</h3><br><br>'
        else:
            company['notes'] = org['quick_notes']
        
        companies.append(company)
    
    return companies

@sleep_and_retry
@limits(calls=MAX_CALLS_PER_MINUTE, period=ONE_MINUTE)
def createCompany(company, existingCompanies, url):
    if company['name'] not in existingCompanies:
        data = {
            "company": company
        }
        r = requests.post(url, headers=headers, json=data)
        print(company['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
        if r.status_code != 200:
            if r.json():
                response = json.dumps(r.json(), indent=4)
            else:
                response = ''
            logging.error(company['name'] + ' creation failed: ' + r.reason + '\n' + url + '\n' + json.dumps(company, indent=4) + '\n' + response)
    else:
        print(company['name'] + ' already exists.')
        logging.warning(company['name'] + ' already exists. No http request was made')

def createCompanies(source = ""):
    endpoint = 'companies'
    url = os.path.join(BASE_URL, endpoint)

    orgs = getCompaniesJson(source)
    cleanedOrgs = rmNonClients(orgs)
    companies = parseCompaniesJson(cleanedOrgs)       
    existingCompanies = getExistingRecords(endpoint, namesonly=True)

    for company in companies:
        createCompany(company,existingCompanies,url)

# def appHeader():
#     os.system('cls')
#     print('# Welcome to Hudu Migrator')
#     print('# Enter help to see a list of available commands')

# appHeader()
# command = ""
# while command not in ['quit','exit','stop']:
#     command = input('> ')
#     if command == 'help':
#         print("# clear - Clear the screen")
#         print("# loadexpdb - Load the ITGlue export database with CSV files found in the path set as the Glue Export Path")
#         print("# crlayouts - Create asset layouts based on the contents of asset_layouts.json")
#         print("# crcompanies  - Create companies based on either the contents of the company and location tables in the glue export database or based on companies and locations from Connectwise Manage")
#     elif command == 'clear':
#         appHeader()
#     elif command == 'loadexpdb':
#         loadExpDb()
#     elif command == 'crlayouts':
#         createlayouts()
#     elif command == 'crcompanies --glue':
#         createCompanies('glue')
#     elif command == 'crcompanies --manage':
#         createCompanies('manage')
#     elif command in ['quit','exit','stop']:
#         print("# Goodbye")
#     else:
#         print("# Not a valid command")
#         print("# Enter help to see a list of available commands")

