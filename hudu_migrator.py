import pandas as pd
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
import requests
import json

load_dotenv()

DB_CON_STR = os.getenv('DB_CON_STR')
GLUE_EXPT_PATH = os.getenv('GLUE_EXPT_PATH')
API_KEY = os.getenv('API_KEY')
BASE_URL = os.getenv('BASE_URL')

headers = {
    'x-api-key':API_KEY,
}

def getExportDB():
    engine = create_engine(DB_CON_STR)
    con = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
    return con

def loaddb():
    for file in os.listdir(GLUE_EXPT_PATH):
        if file.endswith(".csv"):
            df = pd.read_csv(open(GLUE_EXPT_PATH + '/' + file))
            tablename = os.path.splitext(file)[0]
            connection = getExportDB()
            df.to_sql(tablename,con=connection,if_exists='replace',index=False)
            print(file + ' OK')

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

def createcompanies():
    endpoint = 'companies'
    url = os.path.join(BASE_URL, endpoint)

    query = text('SELECT * FROM organizations;')
    connection = getExportDB()
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
        companies.append(company)

    for company in companies:
        data = {
            "company": company
        }

        r = requests.post(url, headers=headers, json=data)
        print(company['name'] + ' ' + str(r.status_code) + ' ' + r.reason)

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
        print("# loaddb - Load the ITGlue export database with CSV files found in the path set as the Glue Export Path")
        print("# crlayouts - Create asset layouts based on the contents of asset_layouts.json")
        print("# crcompanies  - Create companies based on ")
    elif command == 'clear':
        appHeader()
    elif command == 'loaddb':
        loaddb()
    elif command == 'crlayouts':
        createlayouts()
    elif command == 'crcompanies':
        createcompanies()
    elif command in ['quit','exit','stop']:
        print("# Goodbye")
    else:
        print("# Not a valid command")
        print("# Enter help to see a list of available commands")
