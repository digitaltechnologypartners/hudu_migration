import os
from dotenv import load_dotenv
import requests
import json

load_dotenv()

API_KEY = os.getenv('API_KEY')
BASE_URL = os.getenv('BASE_URL')

endpoint = 'asset_layouts'
url = os.path.join(BASE_URL, endpoint)

headers = {
    'x-api-key':API_KEY,
}

file = open('asset_layouts.json')
layouts = json.load(file)
for layout in layouts:
    data = {
        "asset_layout": layout
    }

    fields = data['asset_layout']['fields']
    for field in fields:
        if field['field_type'] == 'AssetLink':
            r = requests.get(url, headers=headers)
            existing_layouts = r.json()['asset_layouts']
            for layout in existing_layouts:
                if layout['name'] == field['linkable_id']:
                    data['asset_layout']['fields'][fields.index(field)]['linkable_id'] = layout['id']

    r = requests.post(url, headers=headers, json=data)
    print(r.status_code)
    print(r.reason)


