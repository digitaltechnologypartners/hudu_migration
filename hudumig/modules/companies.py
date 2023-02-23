import os
from configparser import ConfigParser
import pandas as pd
import json
from sqlalchemy import text
import requests
import logging
from ..utils import getExportDB,getManageDB,getExistingRecords,headers,rateLimiter,getQuery,APILog,writeLeftovers

cfg = ConfigParser()
cfg.read('./config/config.ini')

BASE_URL = cfg['API']['BASE_URL']
TYPE_BLACKLIST = cfg['COMPANIES']['TYPE_BLACKLIST'].split('\n,')
EXCLUSIVE_TYPE_BLAKCLIST = cfg['COMPANIES']['EXCLUSIVE_TYPE_BLACKLIST']

ENDPOINT = 'companies'

def getOrgsJson(orgsDF):
    organizations = orgsDF.to_json(orient = 'records')
    orgsJson = json.loads(organizations)
    return orgsJson

def getOrgsDF(source, query):
    if source == 'glue':
        connection = getExportDB()
    elif source == 'manage':
        connection = getManageDB()
    query = getQuery(query)
    organizations = pd.read_sql(query,con=connection)
    return organizations

def xRef(source, orgsDF):
    if source == 'manage':
        glueQnaQuery = text("""select orgs.name as name
                ,quick_notes 
                ,alert
            from organizations orgs""")
        glueQna = pd.read_sql(glueQnaQuery,con=getExportDB())
        orgsDF = pd.merge(orgsDF, glueQna, on="name", how="left")
    elif source == 'glue':
        manageWebsitesQuery = text("""SELECT com.Company_Name AS name
                ,com.Website_URL AS website
            FROM v_rpt_Company com""")
        manageWebsites = pd.read_sql(manageWebsitesQuery,con=getManageDB())
        orgsDF = pd.merge(orgsDF, manageWebsites, on="name", how="left")
    return orgsDF

def chkTypeBlackList(org):
    keep = True
    try:
        companyTypes = org['organization_type'].split(', ')
        for companyType in companyTypes:
            if companyType in TYPE_BLACKLIST:
                keep = False
                logging.warning('Found type ' + companyType + ' in org ' + org['name'] + '. Org was dropped from migration.')
        if len(companyTypes) == 1 and companyTypes[0] in EXCLUSIVE_TYPE_BLAKCLIST:
            keep = False
    except:
        logging.warning('Company: ' + org['name'] + ' has no organization type(s) specified.')
    return keep

def rmNonClients(organizations):
    orgs = [org for org in organizations if chkTypeBlackList(org)]
    nonOrgs = [org for org in organizations if not chkTypeBlackList(org)]
    return orgs,nonOrgs

def parseOrgsJson(organizations):
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
        company['website'] = org['website']
        if org["alert"] is not None and org['quick_notes'] is not None:
            company['notes'] = '<h3 style="color:#b22222">ALERT: ' + org['alert'] + '</h3><br><br>' + org['quick_notes']
        elif org["alert"] is not None and org['quick_notes'] is None:
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
            APILog(ENDPOINT,company['name'],'error',url=url,data=data,response=r)
        else:
            APILog(ENDPOINT,company['name'],'info',url=None,data=None,response=r)
    else:
        print(company['name'] + ' already exists.')
        APILog(ENDPOINT,company['name'],'warning')

def createCompanies(source,query,xref):
    url = os.path.join(BASE_URL, ENDPOINT)

    orgsDF = getOrgsDF(source,query)
    if xref:
        orgsDF = xRef(source, orgsDF)
    orgsJson = getOrgsJson(orgsDF)
    cleanedOrgs,leftovers = rmNonClients(orgsJson)
    writeLeftovers(leftovers,'companies')
    companies = parseOrgsJson(cleanedOrgs)       
    existingCompanies = getExistingRecords(ENDPOINT, namesonly=True)
    for company in companies:
        createCompany(company,existingCompanies,url)
    