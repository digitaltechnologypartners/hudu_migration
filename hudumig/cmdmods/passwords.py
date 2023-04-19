from hudumig.settings import EXPORT_CON_STR,BASE_URL,HEADERS,VERBOSE_LOGS
from hudumig.utils import getDf,writeLeftovers,getExistingRecords,rateLimiter,APILog,writeJson
from hudumig.cmdmods.assets import cleanAssets,getCompanyIDs
import requests
import os
from time import sleep
import logging
import json

ENDPOINT = 'asset_passwords'

def getAssetsGlueIds():
    endpoint = 'assets'
    assets = getExistingRecords(endpoint)
    print('Getting asset glue ids')
    assetsGlueIds = []
    for asset in assets:
        if asset['asset_type'] not in ['Location']:
            assetGlueId = {}
            assetGlueId['id'] = asset['id']
            assetGlueId['company_id'] = asset['company_id']
            assetGlueId['asset_type'] = asset['asset_type']
            assetGlueId['glue_id'] = 0
            for field in asset['fields']:
                if field['label'] == "Glue ID":
                    assetGlueId['glue_id'] = field['value']
            assetsGlueIds.append(assetGlueId)
    return assetsGlueIds

def checkAssets(asset,cid,pw):
    if asset['company_id'] == cid:
        if pw['glue_id'] is not None and asset['glue_id'] == int(pw['glue_id']):
            return True
        elif asset['asset_type'] == 'Office365 tenant' and ('365' in pw['name'] or 'onmicrosoft.com' in str(pw['username'])):
            return True
    return False

def parsePws(pwJson,companyIds,assetsGlueIds):
    print('Parsing passwords')
    parsedPws = []
    for pw in pwJson:
        cid = companyIds[pw['company']]
        ppw = {}
        ppw['company_id'] = cid
        ppw['passwordable_type'] = pw['passwordable_type']
        ppw['name'] = pw['name']
        ppw['password'] = pw['password']
        ppw['url'] = pw['url']
        ppw['username'] = pw['username']
        ppw['password_type'] = pw['password_type']
        ppw['description'] = pw['description']
        if pw['glue_id'] is not None or ('365' in pw['name'] or 'onmicrosoft.com' in str(pw['username'])):
            linkedAssets = [asset for asset in assetsGlueIds if checkAssets(asset,cid,pw)]
            if len(linkedAssets) > 0:
                ppw['passwordable_id'] = linkedAssets[0]['id']
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
