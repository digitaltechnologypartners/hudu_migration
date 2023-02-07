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
    organizations = json.dump(organizations)
    companies = []

    for org in organizations:
        print(org)
    #     company = {}
    #     company['name'] = org['name']
    #     company['type'] = org['organization_type']
    #     company['id_number'] = org['short_name']
    #     company['notes'] = org['quick_notes']
    #     companies.append(company)

    # for company in companies:
    #     data = {
    #         "company": company
    #     }

    # r = requests.post(url, headers=headers, json=data)
    # print(company['name'] + ' ' + r.status_code + ' ' + r.reason)



command = ""
while command not in ['quit','exit','stop']:
    print('> Enter a command')
    command = input()
    if command == 'help':
        print("> loaddb - Loads the database")
        print("> createlayouts - creates asset layouts")
        print("> createcompanies  - creates companies")
    if command == 'loaddb':
        loaddb()
    if command == 'createlayouts':
        createlayouts()
    if command == 'createcompanies':
        createcompanies()
