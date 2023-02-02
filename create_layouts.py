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
    r = requests.post(url, headers=headers, json=data)
    print(r.status_code)
    print(r.reason)


