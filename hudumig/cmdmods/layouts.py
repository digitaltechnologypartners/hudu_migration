import os
import json
import copy
import requests
from hudumig.utils import getExistingRecords, APILog,rateLimiter
from hudumig.settings import BASE_URL,HEADERS

ENDPOINT = 'asset_layouts'

def parseLayouts(layouts):
    print('Parsing asset layouts.')
    parsedLayouts = []
    commonFields = layouts["common_fields"]
    assetLayouts = layouts["asset_layouts"]
    for assetLayout in assetLayouts:
        assetLayout["color"] = "#0d0a0b"
        assetLayout["icon_color"] = "#FFFFFF"
        assetLayout["active"] = True
        for field in assetLayout["common_fields"]:
            for commonField in commonFields:
                if field == commonField["label"]:
                    assetLayout["fields"].append(commonField)

        assetLayout.pop("common_fields")
        position = 1
        for layoutField in assetLayout['fields']:
            layoutField["position"] = position
            position += 1
        parsedLayouts.append(assetLayout)
    return parsedLayouts

def getLayoutLinkRefs(layout, field):
    existingLayouts = getExistingRecords('asset_layouts')
    for existingLayout in existingLayouts:
        if existingLayout['name'] == field['linkable_id']:
            layout['fields'][layout['fields'].index(field)]['linkable_id'] = existingLayout['id']
    return layout

def updateSelfRefs(selfrefs):
    print('Updating layouts with self-referential AssetTag fields.')
    existingLayouts = getExistingRecords(ENDPOINT)
    for selfref in selfrefs:
        id = 0
        for afield in selfref['fields']:
            if afield['field_type'] == 'AssetTag':
                if isinstance(afield['linkable_id'], str):
                    selfref = getLayoutLinkRefs(selfref, afield)
        for existingLayout in existingLayouts:
            if existingLayout['name'] == selfref['name']:
                id = existingLayout['id']
        url = BASE_URL + ENDPOINT + '/' + str(id)
        data = {
            "asset_layout": selfref
        }
        rateLimiter()
        r = requests.put(url, headers=HEADERS, json=data)
        print(selfref['name'] + ' update status: ' + str(r.status_code) + ': ' + r.reason)
        if r.status_code != 200:
            logtype = 'error'
        else:
            logtype = 'info'
        APILog(ENDPOINT,selfref['name'],logtype,url=url,data=data,response=r)

def createlayouts(filepath):
    url = os.path.join(BASE_URL, ENDPOINT)

    file = open(filepath)
    layoutsjson = json.load(file)
    layouts = parseLayouts(layoutsjson)
    selfrefs = []
    existingLayouts = getExistingRecords(ENDPOINT, namesonly=True)
    print('Writing asset layouts.')
    for layout in layouts:
        if layout['name'] not in existingLayouts:
            fields = layout['fields']
            for field in fields:
                if field['field_type'] == 'AssetTag':
                    if layout['name'] == field['linkable_id']:
                        layout['fields'].remove(field)
                        selfref = copy.deepcopy(layout)
                        selfref['fields'].clear()
                        selfref['fields'].append(field)
                        selfrefs.append(selfref)
                    else:
                        layout = getLayoutLinkRefs(layout, field)
            data = {
                "asset_layout": layout
            }
            rateLimiter()
            r = requests.post(url, headers=HEADERS, json=data)
            print(layout['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
            if r.status_code != 200:
                logtype = 'error'
            else:
                logtype = 'info'
            APILog(ENDPOINT,layout['name'],logtype,url=url,data=data,response=r)
        else:
            print(layout['name'] + ' already exists.')
            APILog(ENDPOINT,layout['name'],'warning')
    if len(selfrefs) > 0:
        updateSelfRefs(selfrefs)
