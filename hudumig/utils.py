from configparser import ConfigParser
import requests
import logging
import json

cfg = ConfigParser()
cfg.read('./config/config.ini')

headers = {
    'x-api-key':cfg['API']['API_KEY'],
}

def getExistingRecords(endpoint, namesonly=False):
    endpointpage = endpoint + '?page='
    records = []
    recordsResultsCount = 25
    pagenum = 1
    while recordsResultsCount == 25:
        url = cfg['API']['BASE_URL'] + endpointpage + str(pagenum)
        r = requests.get(url,headers=headers)
        if r.status_code == 200:
            existing_records = r.json()[endpoint]
            pagenum += 1
            recordsResultsCount = len(existing_records)
            for record in existing_records:
                if namesonly == True:
                    records.append(record['name'])
                else:
                    records.append(record)
        else:
            print('Got an error while getting records for ' + endpoint + ': ' + str(r.status_code) + ' ' + r.reason)
            logging.error('Got an error while getting records for ' + endpoint + ': ' + str(r.status_code) + ' ' + r.reason + '\n' + json.dumps(r.json(), indent=4))
            break
    return records

def writeJson(jsonData, file):
    obj = json.dumps(jsonData, indent=4)
    with open(file, "w") as outfile:
        outfile.write(obj)
