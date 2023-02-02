import os
from dotenv import load_dotenv
import requests

load_dotenv()

API_KEY = os.getenv('API_KEY')
BASE_URL = os.getenv('BASE_URL')

endpoint = 'api_info'
url = os.path.join(BASE_URL, endpoint)

headers = {
    'x-api-key':API_KEY,
}

r = requests.get(url, headers=headers)

print(r.text)