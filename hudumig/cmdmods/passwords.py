from hudumig.settings import EXPORT_CON_STR,BASE_URL,HEADERS
from hudumig.utils import getDf,writeLeftovers,getExistingRecords,rateLimiter,APILog
from hudumig.cmdmods.assets import cleanAssets,getCompanyIDs
import requests
import os
from time import sleep
import logging

ENDPOINT = 'asset_passwords'

def getAssetsGlueIds():
    endpoint = 'assets'
    assets = getExistingRecords(endpoint)
    print('Getting asset glue ids')
    assetsGlueIds = []
    for asset in assets:
        if asset['asset_type'] not in ['Location','Office365 tenant']:
            assetGlueId = {}
            assetGlueId['id'] = asset['id']
            assetGlueId['company_id'] = asset['company_id']
            for field in asset['fields']:
                if field['label'] == 'Glue ID':
                    assetGlueId['glue_id'] = field['value']
            assetsGlueIds.append(assetGlueId)
    return assetsGlueIds

def checkAsset(asset,gid,cid):
    if asset['glue_id'] == gid and asset['company_id'] == cid:
        return True
    else:
        return False

def parsePws(pwJson,companyIds,assetsGlueIds):
    print('Parsing passwords')
    parsedPws = []
    for pw in pwJson:
        ppw = {}
        ppw['company_id'] = companyIds[pw['company']]
        ppw['passwordable_type'] = pw['passwordable_type']
        ppw['name'] = pw['name']
        ppw['password'] = pw['password']
        ppw['url'] = pw['url']
        ppw['username'] = pw['username']
        ppw['password_type'] = pw['password_type']
        ppw['description'] = pw['description']
        if pw['glue_id'] is not None:
            linkedAsset = [asset for asset in assetsGlueIds if checkAsset(asset,pw['glue_id'],companyIds[pw['company']])]
            if len(linkedAsset) > 0:
                ppw['passwordable_id'] = linkedAsset[0]['id']
            else:
                logging.warn("Couldn't find linked asset for Password " + pw['name'] + ' under company ' + pw['company'] + '.')
        parsedPws.append(ppw)
    return parsedPws

def createPassword(pw,url):
    rateLimiter()
    data = {
        'asset_password':pw
    }
    r = requests.post(url,headers=HEADERS,json=data)
    print('Password: ' + pw['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
    if r.status_code != 200:
        logtype = 'error'
    else:
        logtype = 'info'
    APILog(ENDPOINT,pw['name'],logtype,url=url,data=data,response=r)
    return r.status_code

def createPasswords(query):
    companyIds = getCompanyIDs()
    pwdf = getDf(query,EXPORT_CON_STR)
    pwJson,leftovers = cleanAssets(pwdf,ENDPOINT)
    writeLeftovers(leftovers,ENDPOINT)
    assetsGlueIds = getAssetsGlueIds()
    parsedPws = parsePws(pwJson,companyIds,assetsGlueIds)
    url = os.path.join(BASE_URL,ENDPOINT)
    print('Writing paswords')
    for pw in parsedPws:
        code = createPassword(pw,url)
        if code == 429:
            sleep(60)
            createPassword(pw,url)
