import os
import click
from configparser import ConfigParser
import requests
import logging
import json
import pandas as pd
from sqlalchemy import create_engine,text
from ratelimit import limits, sleep_and_retry
import traceback

MINUTE = 60
MAX_CALLS = 300

cfg = ConfigParser()
cfg.read('./config/config.ini')

GLUE_DB_CON_STR = cfg['DATABASE']['GLUE_DB_CON_STR']
MANG_DB_CON_STR = cfg['DATABASE']['MANG_DB_CON_STR']
LEFTOVERS_DB_CON_STR = cfg['DATABASE']['LEFTOVERS_DB_CON_STR']

GLUE_EXPT_PATH = cfg['DATABASE']['GLUE_EXPT_PATH']
BASE_URL = cfg['API']['BASE_URL']
API_KEY = cfg['API']['API_KEY']

headers = {
    'x-api-key':API_KEY,
}

def getResponseRequestType(response):
    type = str(response.request)
    type = type[(type.find(' ')):(type.find('>'))]
    return type

def APILog(endpoint, entityname, logtype, url=None, data=None, response=None):
    if logtype == 'error':
        try:
            errorContent = json.dumps(response.json(), indent=4)
        except:
            errorContent = response.text
        logging.error(endpoint + ': ' + entityname + ':' + getResponseRequestType(response) + ' failed: ' + str(response.status_code) + ': ' + response.reason + '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + errorContent)
    elif logtype == 'warning':
        logging.warning(endpoint + ': ' + entityname + ': already exists. No HTTP request was made.')
    elif logtype == 'info':
        logging.info(endpoint + ': ' + entityname + ':' + getResponseRequestType(response) + ' succeeded: ' + str(response.status_code) + ': ' + response.reason)

def getErrorClass(error):
    eClass = str(error.__class__)
    eClass = eClass[eClass.find("'"):eClass.find('>')]
    return eClass

def stackLog(error,action):
    logging.error(action + ' got: ' + getErrorClass(error) + ': ' + str(error) + '\n' + traceback.format_exc())

@sleep_and_retry
@limits(calls=MAX_CALLS, period=MINUTE)
def rateLimiter():
    pass

def getExportDB():
    engine = create_engine(GLUE_DB_CON_STR)
    con = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
    return con

def getManageDB():
    engine = create_engine(MANG_DB_CON_STR)
    con = engine.connect()
    return con

def getLeftoversDB():
    engine = create_engine(LEFTOVERS_DB_CON_STR)
    con = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
    return con

def getQuery(sqlFile):
    with open(sqlFile) as file:
        query = text(file.read())
    return query

def loadExpDb(path):
    for file in os.listdir(path):
        if file.endswith(".csv"):
            df = pd.read_csv(open(path + '/' + file))
            tablename = os.path.splitext(file)[0]
            connection = getExportDB()
            df.to_sql(tablename,con=connection,if_exists='replace',index=False)
            print(file + ' OK')

def writeLeftovers(jsonObj,tablename,flatten=False):
    connection = getLeftoversDB()
    tablename = tablename.lower()
    tablename = tablename.replace(" ","_")
    df = pd.read_json(json.dumps(jsonObj))
    if flatten:
        df = pd.json_normalize(df)
    df.to_sql(tablename,con=connection,if_exists='replace',index=False)

def getExistingRecords(endpoint, namesonly=False):
    if not endpoint.endswith('&'):
        endpointpage = endpoint + '?page='
    else:
        endpointpage = endpoint + 'page='
    records = []
    recordsResultsCount = 25
    pagenum = 1
    while recordsResultsCount == 25:
        rateLimiter()
        url = BASE_URL + endpointpage + str(pagenum)
        r = requests.get(url,headers=headers)
        if r.status_code == 200:
            if endpoint.endswith('&'):
                endpoint = endpoint[:(endpoint.find('?'))]
            elif '/' in endpoint:
                endpoint = endpoint[:(endpoint.find('s/'))]
            existing_records = r.json()[endpoint]
            pagenum += 1
            if isinstance(existing_records, list):
                recordsResultsCount = len(existing_records)
                for record in existing_records:
                    if namesonly == True:
                        records.append(record['name'])
                    else:
                        records.append(record)
            else:
                recordsResultsCount = 1
                records.append(existing_records)
        else:
            print('Got an error while getting records for ' + endpoint + ': ' + str(r.status_code) + ' ' + r.reason)
            APILog(endpoint,'Page ' + str(pagenum),'error',url=url,data='',response=r)
            break
    return records

def writeJson(jsonData, file):
    obj = json.dumps(jsonData, indent=4)
    with open(file, "w") as outfile:
        outfile.write(obj)

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