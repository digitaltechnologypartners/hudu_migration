import os
import logging
import json
import copy
import requests
from configparser import ConfigParser
from ..utils import getExistingRecords, headers

cfg = ConfigParser()
cfg.read('./config/config.ini')

BASE_URL = cfg['API']['BASE_URL']

def parseLayouts(layouts):
    parsedLayouts = []

    commonFields = layouts["common_fields"]
    assetLayouts = layouts["asset_layouts"]

    for assetLayout in assetLayouts:
        assetLayout["color"] = "#000000"
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

def createlayouts(filepath):
    endpoint = 'asset_layouts'
    url = os.path.join(BASE_URL, endpoint)

    file = open(filepath)
    layoutsjson = json.load(file)
    layouts = parseLayouts(layoutsjson)
    selfrefs = []
    for layout in layouts:
        existingLayouts = getExistingRecords(endpoint, namesonly=True)
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
            r = requests.post(url, headers=headers, json=data)
            print(layout['name'] + ' ' + str(r.status_code) + ' ' + r.reason)
            if r.status_code != 200:
                logging.error('asset_layout: ' + layout['name'] + ' creation failed: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + json.dumps(r.json(), indent=4))
            else:
                logging.info('asset_layout: ' + layout['name'] + ' creation info: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4))
        else:
            print(layout['name'] + ' already exists.')
            logging.warning('asset_layout: ' + layout['name'] + 'already exists. No http request was made.')
    if len(selfrefs) > 0:
        existingLayouts = getExistingRecords(endpoint)
        for selfref in selfrefs:
            id = 0
            for afield in selfref['fields']:
                if afield['field_type'] == 'AssetTag':
                    if isinstance(afield['linkable_id'], str):
                        selfref = getLayoutLinkRefs(selfref, afield)
            for existingLayout in existingLayouts:
                if existingLayout['name'] == selfref['name']:
                    id = existingLayout['id']
            url = BASE_URL + endpoint + '/' + str(id)
            data = {
                "asset_layout": selfref
            }
            r = requests.put(url, headers=headers, json=data)
            print(selfref['name'] + ' update status: ' + str(r.status_code) + ': ' + r.reason)
            if r.status_code != 200:
                logging.error('asset_layout: ' + selfref['name'] + ' update failed: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4) + '\n' + json.dumps(r.json(), indent=4))
            else:
                logging.info('asset_layout: ' + selfref['name'] + ' update info: ' + r.reason + '\n' + url + '\n' + json.dumps(data, indent=4))
