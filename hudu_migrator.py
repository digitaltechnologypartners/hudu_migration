import pandas as pd
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
import requests
import json
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(filename='migrator.log', filemode='w', level=logging.INFO, \
    format='%(asctime)s:%(levelname)s:%(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

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

def getExistingRecords(endpoint):
    endpointpage = endpoint + '?page='
    records = []
    recordsResultsCount = 25
    pagenum = 1
    while recordsResultsCount == 25:
        url = BASE_URL + endpointpage + str(pagenum)
        r = requests.get(url,headers=headers)
        existing_records = r.json()['endpoint']
        pagenum += 1
        recordsResultsCount = len(existing_records)
        for record in existing_records:
            records.append(record)
    return records

def createlayouts():
    endpoint = 'asset_layouts'
    url = os.path.join(BASE_URL, endpoint)

    file = open('asset_layouts.json')
    layouts = json.load(file)
    for layout in layouts:
        data = {
            "asset_layout": layout
        }

        fields = data['asset_layout']['fields']
        for field in fields:
            if field['field_type'] == 'AssetLink':
                r = requests.get(url, headers=headers)
                existing_layouts = r.json()['asset_layouts']
                for layout in existing_layouts:
                    if layout['name'] == field['linkable_id']:
                        data['asset_layout']['fields'][fields.index(field)]['linkable_id'] = layout['id']

        r = requests.post(url, headers=headers, json=data)
        print(r.status_code)
        print(r.reason)

def createcompanies(source = ""):
    endpoint = 'companies'
    url = os.path.join(BASE_URL, endpoint)
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
        query = text('')
        connection = getManageDB()

    organizations = pd.read_sql(query,con=connection)
    organizations = organizations.to_json(orient = 'records')
    organizations = json.loads(organizations)
    companies = []

    for org in organizations:
        company = {}
        company['name'] = org['name']
        company['company_type'] = org['organization_type']
        company['id_number'] = org['short_name']
        company['notes'] = org['quick_notes']
        company['address_line_1'] = org['address_1']
        company['address_line_2'] = org['address_2']
        company['city'] = org['city']
        company['state'] = org['region']
        company['zip'] = org['postal_code']
        company['country_name'] = org['country']
        company['phone_number'] = org['phone']
        company['fax_number'] = org['fax']
        companies.append(company)
        
    existingCompanies = getExistingRecords(endpoint)

    for company in companies:
        if company['name'] not in existingCompanies:
            data = {
                "company": company
            }
            r = requests.post(url, headers=headers, json=data)
            print(company['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
            if r.status_code != 200:
                companyString = '{\n'
                for item in company:
                    companyString += '    "' + item + '":"' + str(company[item]) + '",\n'
                companyString += '}'
                logging.error(company['name'] + ' creation failed: ' + r.reason + '\n' + companyString)
        else:
            print(company['name'] + ' already exists.')

def appHeader():
    os.system('cls')
    print('# Welcome to Hudu Migrator')
    print('# Enter help to see a list of available commands')

appHeader()
command = ""
while command not in ['quit','exit','stop']:
    command = input('> ')
    if command == 'help':
        print("# clear - Clear the screen")
        print("# loadexpdb - Load the ITGlue export database with CSV files found in the path set as the Glue Export Path")
        print("# crlayouts - Create asset layouts based on the contents of asset_layouts.json")
        print("# crcompanies  - Create companies based on either the contents of the company and location tables in the glue export database or based on companies and locations from Connectwise Manage")
    elif command == 'clear':
        appHeader()
    elif command == 'loadexpdb':
        loadExpDb()
    elif command == 'crlayouts':
        createlayouts()
    elif command == 'crcompanies --glue':
        createcompanies('glue')
    elif command == 'crcompanies --manage':
        createcompanies('manage')
    elif command in ['quit','exit','stop']:
        print("# Goodbye")
    else:
        print("# Not a valid command")
        print("# Enter help to see a list of available commands")

