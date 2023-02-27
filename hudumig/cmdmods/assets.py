import os
import click
import json
import pandas as pd
import requests
import logging
from hudumig.utils import getQuery,getExportDB,getExistingRecords,rateLimiter,APILog,stackLog,writeLeftovers
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

def getAssetsDF(query):
    connection = getExportDB()
    query = getQuery(query)
    assetsDF = pd.read_sql(query,con=connection)
    return assetsDF

def getSchema(layout):
    layoutFieldNames = []
    for field in layout['fields']:
        layoutFieldNames.append(field['label'])
    return layoutFieldNames

def checkSchema(layoutFieldNames,assetsDF):
    try:
        assetsDF = assetsDF.drop(['company','name'],axis=1)
    except Exception as e:
        raise
    dfColumnNames = list(assetsDF.columns)
    dfColumnNames.sort()
    layoutFieldNames.sort()
    if layoutFieldNames != dfColumnNames:
        raise Exception("Query does not return a schema that matches the selected asset layout.")

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

def parseAssetsJson(assetsJson,assetLayoutID):
    parsedAssests = []
    for record in assetsJson:
        asset = {}
        asset['company'] = record['company']
        asset['asset_layout_id'] = assetLayoutID
        asset['name'] = record['name']
        asset['custom_fields'] = []
        record.pop('company')
        record.pop('name')
        asset['custom_fields'].append(record)
        parsedAssests.append(asset)
    return parsedAssests

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
    return companyID,asset

def createAsset(asset,assettype,companyIDs):
    companyID,asset = getCompanyID(asset,companyIDs)
    if companyID != 0:
        rateLimiter()
        endpoint = 'companies/' + str(companyID) + '/assets'
        url = os.path.join(BASE_URL, endpoint)
        data = {
            "asset":asset
        }
        r = requests.post(url,headers=HEADERS,json=data)
        print(assettype + ' asset: '+ asset['name'] + ': ' + str(r.status_code) + ' ' + r.reason)
        if r.status_code != 200:
            APILog(assettype + ' asset',asset['name'],'error',url=url,data=data,response=r)
        else:
            APILog(assettype + ' asset',asset['name'],'info',url=None,data=None,response=r)
    
def createAssets(layoutId,layout,assettype,query):
    assetsDF = getAssetsDF(query)
    schema = getSchema(layout)
    checkSchema(schema,assetsDF)
    assetsJson,leftovers = cleanAssets(assetsDF,assettype)
    writeLeftovers(leftovers,assettype)
    parsedAssets = parseAssetsJson(assetsJson,layoutId)
    companyIDs = getCompanyIDs()
    for asset in parsedAssets:
        createAsset(asset,assettype,companyIDs)