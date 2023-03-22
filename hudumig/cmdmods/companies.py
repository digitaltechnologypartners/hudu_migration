import os
import pandas as pd
import json
from sqlalchemy import text
import requests
import logging
from hudumig.utils import getDb,getExistingRecords,rateLimiter,APILog,writeLeftovers,getDf
from hudumig.settings import BASE_URL,TYPE_BLACKLIST,EXCLUSIVE_TYPE_BLACKLIST,HEADERS,EXPORT_CON_STR,MANG_DB_CON_STR

ENDPOINT = 'companies'

def getOrgsJson(orgsDF):
    print('Getting company Json.')
    organizations = orgsDF.to_json(orient = 'records')
    orgsJson = json.loads(organizations)
    return orgsJson

def xRef(source, orgsDF):
    print('Cross referencing company data.')
    if source == 'manage':
        glueQnaQuery = text("""select orgs.name as name, quick_notes, alert from organizations orgs""")
        glueQna = pd.read_sql(glueQnaQuery,con=getDb(EXPORT_CON_STR))
        orgsDF = pd.merge(orgsDF, glueQna, on="name", how="left")
    elif source == 'glue':
        manageWebsitesQuery = text("""SELECT com.Company_Name AS name, com.Website_URL AS website FROM v_rpt_Company com""")
        manageWebsites = pd.read_sql(manageWebsitesQuery,con=getDb(MANG_DB_CON_STR))
        orgsDF = pd.merge(orgsDF, manageWebsites, on="name", how="left")
    return orgsDF

def chkTypeBlackList(org):
    keep = True
    try:
        companyTypes = org['organization_type'].split(', ')
        for companyType in companyTypes:
            if companyType in TYPE_BLACKLIST:
                keep = False
            if len(companyTypes) == 1 and companyType in EXCLUSIVE_TYPE_BLACKLIST:
                keep = False
            if keep == False:
                logging.warning('Found type ' + companyType + ' in org ' + org['name'] + '. Org was dropped from migration.')
    except:
        logging.warning('Company: ' + org['name'] + ' has no organization type(s) specified.')
    return keep

def rmNonClients(organizations):
    print('Removing non-clients from companies.')
    orgs = [org for org in organizations if chkTypeBlackList(org)]
    nonOrgs = [org for org in organizations if not chkTypeBlackList(org)]
    return orgs,nonOrgs

def parseOrgsJson(organizations):
    print('Parsing companies.')
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
        r = requests.post(url, headers=HEADERS, json=data)
        print(company['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
        if r.status_code != 200:
            logtype = 'error'            
        else:
            logtype = 'info'
        APILog(ENDPOINT,company['name'],logtype,url=url,data=data,response=r)
    else:
        print(company['name'] + ' already exists.')
        APILog(ENDPOINT,company['name'],'warning')

def createCompanies(source,query,xref):
    url = os.path.join(BASE_URL, ENDPOINT)
    if source == 'glue':
        orgsDF = getDf(query,EXPORT_CON_STR)
    elif source == 'manage':
        orgsDF = getDf(query,MANG_DB_CON_STR)
    if xref:
        orgsDF = xRef(source, orgsDF)
    orgsJson = getOrgsJson(orgsDF)
    cleanedOrgs,leftovers = rmNonClients(orgsJson)
    writeLeftovers(leftovers,'companies')
    companies = parseOrgsJson(cleanedOrgs)       
    existingCompanies = getExistingRecords(ENDPOINT, namesonly=True)
    print('Writing companies.')
    for company in companies:
        createCompany(company,existingCompanies,url)
    