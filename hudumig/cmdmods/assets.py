import os
import click
import json
import requests
import logging
from hudumig.utils import getExistingRecords,rateLimiter,APILog,stackLog,writeLeftovers,getDf
from hudumig.settings import BASE_URL,HEADERS

def getAssetLayoutAndID(layoutName):
    layoutID = None
    assetLayout = None
    try:
        layouts = getExistingRecords('asset_layouts')
        for layout in layouts:
            if layout['name'] == layoutName:
                layoutID = layout['id']
                assetLayout = layout
        return layoutID, assetLayout
    except Exception as e:
        stackLog(e,'get asset layout id')
        click.echo('Got an error attempting to get asset layout id. Check the logs.')

def getLocationsLookupTable():
    rateLimiter()
    layoutID,layout = getAssetLayoutAndID('Location')
    data = {
        "asset_layout_id":layoutID
    }
    endpoint = 'assets'
    locations = getExistingRecords(endpoint,namesonly=False,data=data)
    locationsLookupTable = []
    for location in locations:
        loc = {}
        loc['company_id'] = location['company_id']
        loc['company_name'] = location['company_name']
        loc['id'] = location['id']
        loc['slug'] = location['slug']
        loc['name'] = location['name']
        locationsLookupTable.append(loc)
    return locationsLookupTable

def getLocation(locationsLookupTable,locName,companyName):
    for location in locationsLookupTable:
        if location['name'] == locName and location['company_name'] == companyName:
            loc = '[{\"id\":' + str(location['id']) + ',\"url\":\"/a/' + location['slug'] + '\",\"name\":\"' + location['name'] + '\"}]'
            return loc

def getSchema(layout):
    layoutFieldNames = []
    for field in layout['fields']:
        layoutFieldNames.append(field['label'])
    return layoutFieldNames

def checkSchema(layoutFieldNames,assetsDF):
    try:
        assetsDF = assetsDF.drop(['company','name','archived'],axis=1)
    except Exception as e:
        raise
    dfColumnNames = list(assetsDF.columns)
    dfColumnNames = dfColumnNames.sort()
    layoutFieldNames = layoutFieldNames.sort()
    if layoutFieldNames != dfColumnNames:
        raise Exception("Query does not return a schema that matches the selected asset layout. \nLayout requires: " + str(layoutFieldNames) + "\nBut got: " + str(dfColumnNames))

def cleanAssets(assetsDF,assettype):
    assetsJson = []
    leftovers = []
    companies = getExistingRecords('companies',namesonly=True)
    initJson = assetsDF.to_json(orient = 'records')
    initJson = json.loads(initJson)
    for record in initJson:
        if record['company'] in companies:
            assetsJson.append(record)
        else:
            leftovers.append(record)
            logging.warning('Company: ' + record['company'] + ' not found in Hudu. ' + assettype + ' asset: ' + record['name'] + ' will be discarded')
    return assetsJson,leftovers

def getCompanyIDs():
    companyIDs = {}
    companies = getExistingRecords('companies')
    for company in companies:
        companyIDs[company['name']] = company['id']
    return companyIDs

def getCompanyID(asset,companyIDs):
    companyID = 0
    company = asset.pop('company')
    for key,value in companyIDs.items():
        if key == company:
            companyID = value
    if companyID == 0:
        logging.warning('company: ' + company + ' not found in Hudu. Asset will be discarded')
    return company,companyID,asset

def parseAssetsJson(assetsJson,assetLayoutID,assettype):
    parsedAssets = []
    if assettype != 'Location':
        locationsLookupTable = getLocationsLookupTable()
    for record in assetsJson:
        asset = {}
        asset['company'] = record['company']
        asset['asset_layout_id'] = assetLayoutID
        asset['name'] = record['name']
        asset['archived'] = record['archived']
        asset['custom_fields'] = []
        companyName = record.pop('company')
        record.pop('name')
        record.pop('archived')
        if 'Location' in record:
            location = getLocation(locationsLookupTable,record['Location'],companyName)
            record['Location'] = location
        asset['custom_fields'].append(record)
        parsedAssets.append(asset)
    return parsedAssets

def createAsset(asset,assettype,companyIDs):
    company,companyID,asset = getCompanyID(asset,companyIDs)
    if companyID != 0:
        rateLimiter()
        endpoint = 'companies/' + str(companyID) + '/assets'
        url = os.path.join(BASE_URL, endpoint)
        archival = asset.pop('archived')
        data = {
            "asset":asset
        }
        r = requests.post(url,headers=HEADERS,json=data)
        print(assettype + ' asset: '+ asset['name'] + ' for company ' + company + ': ' + str(r.status_code) + ' ' + r.reason)
        if r.status_code != 200:
            APILog(assettype + ' asset',asset['name'] + ' for company ' + company,'error',url=url,data=data,response=r)
        else:
            APILog(assettype + ' asset',asset['name'] + ' for company ' + company,'info',url=None,data=data,response=r)
            if archival == 'Yes':
                assetId = r.json()['asset']['id']
                archiveAsset(assetId,companyID)

def archiveAsset(assetId,companyId):
    rateLimiter()
    endpoint = 'companies/' + str(companyId) + '/assets/' + str(assetId) + '/archive'
    url = os.path.join(BASE_URL, endpoint)
    r = requests.put(url,headers=HEADERS)
    data = {"asset":assetId,"company":companyId}
    if r.status_code != 200:
        APILog('Archival of asset',str(assetId) + ' for company' + str(companyId),'error',url=url,data=data,response=r)
    else:
        APILog('Archival of asset',str(assetId) + ' for company' + str(companyId),'info',url=None,data=None,response=r)

def createAssets(layoutId,layout,assettype,query):
    assetsDF = getDf(query)
    schema = getSchema(layout)
    checkSchema(schema,assetsDF)
    assetsJson,leftovers = cleanAssets(assetsDF,assettype)
    writeLeftovers(leftovers,assettype)
    companyIDs = getCompanyIDs()
    parsedAssets = parseAssetsJson(assetsJson,layoutId,assettype)
    for asset in parsedAssets:
        createAsset(asset,assettype,companyIDs)