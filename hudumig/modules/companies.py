import os
from configparser import ConfigParser
import pandas as pd
import json
from sqlalchemy import text
import requests
import logging
from ..utils import getExportDB,getManageDB,getExistingRecords,headers,rateLimiter,getQuery

cfg = ConfigParser()
cfg.read('./config/config.ini')

BASE_URL = cfg['API']['BASE_URL']
TYPE_BLACKLIST = cfg['COMPANIES']['TYPE_BLACKLIST']

def getCompaniesJson(source, query):
    if source == 'glue':
        connection = getExportDB()
    elif source == 'manage':
        connection = getManageDB()

    query = getQuery(query)

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
    companyTypes = org['organization_type'].split(', ')
    for companyType in companyTypes:
        if companyType in TYPE_BLACKLIST:
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

def createCompany(company, existingCompanies, url):
    rateLimiter()
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

def createCompanies(source,query):
    endpoint = 'companies'
    url = os.path.join(BASE_URL, endpoint)

    orgs = getCompaniesJson(source,query)
    cleanedOrgs = rmNonClients(orgs)
    companies = parseCompaniesJson(cleanedOrgs)       
    existingCompanies = getExistingRecords(endpoint, namesonly=True)

    for company in companies:
        createCompany(company,existingCompanies,url)