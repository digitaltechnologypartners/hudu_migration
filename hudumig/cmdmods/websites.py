import requests
import os
from hudumig.settings import HEADERS,BASE_URL
from hudumig.utils import getDf,writeLeftovers,rateLimiter,APILog,getExistingRecords
from hudumig.cmdmods.assets import getCompanyIDs,getCompanyID,cleanAssets

ENDPOINT = 'websites'

def getCompaniesWebsites():
    companies = getExistingRecords('companies')
    companiesWebsites = []
    for company in companies:
        if company['website'] is not None and company['website'] != "":
            companyWebsite = {}
            companyWebsite['name'] = company['website']
            companyWebsite['notes'] = None
            companyWebsite['company'] = company['name']
            companiesWebsites.append(companyWebsite)
    return companiesWebsites

def uniformifyName(name):
    name = name.rstrip('/')
    name = name.lower()
    removeList = ['https://','http://','www.']
    for x in removeList:
        if x in name:
            name = name.replace(x,'')
    return name

def checkImport(website,websitesJson):
    keep = True
    for site in websitesJson:
        if website == site:
            keep = False
    return keep

def xrefImportandExisting(websitesJson,companiesWebsites):
    for cWebsite in companiesWebsites:
        name = uniformifyName(cWebsite['name'])
        cWebsite['name'] = name
    cWebsites = [site for site in companiesWebsites if checkImport(site,websitesJson)]
    allWebsitesJson = websitesJson + cWebsites
    return allWebsitesJson

def createWebsite(website,companyIDs):
    company,companyId,website = getCompanyID(website,companyIDs)
    if companyId != 0:
        rateLimiter()
        website['company_id'] = companyId
        website['name'] = 'https://' + website['name']
        url = os.path.join(BASE_URL,ENDPOINT)
        data = {
            'website':website
        }
        r = requests.post(url,headers=HEADERS,json=data)
        print('Website: '+ website['name'] + ' for company ' + company + ': ' + str(r.status_code) + ' ' + r.reason)
        if r.status_code != 200:
            APILog('Website',website['name'] + ' for company ' + company,'error',url=url,data=data,response=r)
        else:
            APILog('Website',website['name'] + ' for company ' + company,'info',url=None,data=data,response=r)

def createWebsites(query):
    companyIDs = getCompanyIDs()
    websitesDf = getDf(query)
    websitesJson,leftovers = cleanAssets(websitesDf,ENDPOINT)
    companiesWebsites = getCompaniesWebsites()
    websitesJson = xrefImportandExisting(websitesJson,companiesWebsites)
    writeLeftovers(leftovers,ENDPOINT)
    for website in websitesJson:
        createWebsite(website,companyIDs)

    
