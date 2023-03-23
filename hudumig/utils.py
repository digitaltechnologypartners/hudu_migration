import requests
import logging
import json
import pandas as pd
from sqlalchemy import create_engine,text
from ratelimit import limits, sleep_and_retry
import traceback
from hudumig.settings import EXPORT_CON_STR,LEFTOVERS_DB_CON_STR,BASE_URL,HEADERS,MAX_CALLS,MINUTE,VERBOSE_LOGS,WRITE_LEFTOVERS

def getResponseRequestType(response):
    type = str(response.request)
    type = type[(type.find(' ')):(type.find('>'))]
    return type

def APILog(endpoint, entityname, logtype, url=None, data=None, response=None):
    try:
        errorContent = json.dumps(response.json(), indent=4)
    except:
        errorContent = response.text
    if VERBOSE_LOGS == 'True':
        verbose = '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + errorContent
    else:
        verbose = ''
    if logtype == 'error':
        logging.error(endpoint + ': ' + entityname + ':' + getResponseRequestType(response) + ' failed: ' + str(response.status_code) + ': ' + response.reason + verbose)
    elif logtype == 'warning':
        logging.warning(endpoint + ': ' + entityname + ': already exists. No HTTP request was made.')
    elif logtype == 'info':
        logging.info(endpoint + ': ' + entityname + ':' + getResponseRequestType(response) + ' succeeded: ' + str(response.status_code) + ': ' + response.reason + verbose)

def getErrorClass(error):
    eClass = str(error.__class__)
    eClass = eClass[eClass.find("'"):eClass.find('>')]
    return eClass

def stackLog(error,action):
    if VERBOSE_LOGS == 'True':
        verbose = '\n' + traceback.format_exc()
    else: 
        verbose = ''
    logging.error(action + ' got: ' + getErrorClass(error) + ': ' + str(error) + verbose)

@sleep_and_retry
@limits(calls=MAX_CALLS, period=MINUTE)
def rateLimiter():
    pass

def getDb(conStr):
    engine = create_engine(conStr)
    if conStr in [EXPORT_CON_STR,LEFTOVERS_DB_CON_STR]:
        con = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
    else:
        con = engine.connect()
    return con

def getQuery(sqlFile):
    with open(sqlFile) as file:
        query = text(file.read())
    return query

def getDf(query,conStr):
    print('Querying database.')
    connection = getDb(conStr)
    query = getQuery(query)
    df = pd.read_sql(query,con=connection)
    return df

def writeLeftovers(jsonObj,tablename,flatten=False):
    if WRITE_LEFTOVERS == 'True':
        print('Writing leftover data items to leftovers db.')
        connection = getDb(LEFTOVERS_DB_CON_STR)
        tablename = tablename.lower()
        tablename = tablename.replace(" ","_")
        df = pd.read_json(json.dumps(jsonObj))
        if flatten:
            df = pd.json_normalize(df)
        df.to_sql(tablename,con=connection,if_exists='replace',index=False)

def getExistingRecords(endpoint, namesonly=False, data=None):
    print('Getting existing records for ' + endpoint.rstrip('&'))
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
        r = requests.get(url,headers=HEADERS,data=data)
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
    print('Writing json output to ' + file)
    obj = json.dumps(jsonData, indent=4)
    with open(file, "w") as outfile:
        outfile.write(obj)