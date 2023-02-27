from configparser import ConfigParser

### Default location of config.ini
DEFAULT_CONFIG_PATH = './config/config.ini'

cfg = ConfigParser()
cfg.read(DEFAULT_CONFIG_PATH)

### Variables imported from config.ini
API_KEY = cfg['API']['api_key']
BASE_URL = cfg['API']['base_url']

EXPORT_CON_STR = cfg['DATABASE']['export_con_str']
LEFTOVERS_DB_CON_STR = cfg['DATABASE']['leftovers_db_con_str']
MANG_DB_CON_STR = cfg['DATABASE']['mang_db_con_str']
GLUE_EXPT_PATH = cfg['DATABASE']['glue_expt_path']

ASSET_LAYOUTS_JSON = cfg['ASSET_LAYOUTS']['asset_layouts_json']
ASSET_LAYOUTS_OUTPUT = cfg['ASSET_LAYOUTS']['asset_layouts_output']

COMPANIES_QUERY = cfg['COMPANIES']['companies_query']
COMPANIES_OUTPUT = cfg['COMPANIES']['COMPANIES_OUTPUT']
TYPE_BLACKLIST = cfg['COMPANIES']['companies_output'].split('\n,')
EXCLUSIVE_TYPE_BLACKLIST = cfg['COMPANIES']['type_blacklist'].split('\n,')

### API Call Variables
HEADERS = {
    'x-api-key':API_KEY
}

### Ratelimiter Variables
MINUTE = 60
MAX_CALLS = 300
