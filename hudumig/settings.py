from configparser import ConfigParser
from sqlalchemy.engine.url import URL

### Default location of config.ini
DEFAULT_CONFIG_PATH = './config/config.ini'

cfg = ConfigParser()
cfg.read(DEFAULT_CONFIG_PATH)

### Paths
CONFIG_PATH = cfg['PATHS']['config']
OUTPUT_PATH = cfg['PATHS']['output']
SQL_PATH = cfg['PATHS']['sql']
GLUE_EXPT_PATH = cfg['PATHS']['glue_expt_path']

### API
API_KEY = cfg['API']['api_key']
BASE_URL = cfg['API']['base_url']

### Database

EXPORT_CON_STR = URL(
    'mysql+pymysql',
    username = cfg['DATABASE']['mdb_uname'],
    password = cfg['DATABASE']['mdb_pw'],
    host = cfg['DATABASE']['mdb_host'],
    port = cfg['DATABASE']['mdb_port'],
    database = cfg['DATABASE']['mdb_schema']
)
LEFTOVERS_DB_CON_STR = URL(
    'mysql+pymysql',
    username = cfg['DATABASE']['ldb_uname'],
    password = cfg['DATABASE']['ldb_pw'],
    host = cfg['DATABASE']['ldb_host'],
    port = cfg['DATABASE']['ldb_port'],
    database = cfg['DATABASE']['ldb_schema']
)
MANG_DB_CON_STR = URL(
    'mssql+pymssql',
    username = cfg['DATABASE']['mng_uname'],
    password = cfg['DATABASE']['mng_pw'],
    host = cfg['DATABASE']['mng_host'],
    port = cfg['DATABASE']['mng_port'],
    database = cfg['DATABASE']['mng_schema']
)

### Asset Layouts
ASSET_LAYOUTS_JSON = CONFIG_PATH + cfg['ASSET_LAYOUTS']['asset_layouts_json']
ASSET_LAYOUTS_OUTPUT = OUTPUT_PATH + cfg['ASSET_LAYOUTS']['asset_layouts_output']

### Companies
COMPANIES_QUERY = SQL_PATH + cfg['COMPANIES']['companies_query']
COMPANIES_OUTPUT = OUTPUT_PATH + cfg['COMPANIES']['companies_output']
TYPE_BLACKLIST = cfg['COMPANIES']['type_blacklist'].split(',\n')
EXCLUSIVE_TYPE_BLACKLIST = cfg['COMPANIES']['exclusive_type_blacklist'].split(',\n')

### Websites
WEBSITES_QUERY = SQL_PATH + cfg['WEBSITES']['websites_query']
WEBSITES_OUTPUT = OUTPUT_PATH + cfg['WEBSITES']['websites_output']

### Logging
DEFAULT_LOG_FILE = cfg['LOGGING']['default_log_file']
VERBOSE_LOGS = cfg['LOGGING']['verbose_logs']

### API Call Variables
HEADERS = {
    'x-api-key':API_KEY
}

### Ratelimiter Variables
MINUTE = 60
MAX_CALLS = 300

### Write leftovers
WRITE_LEFTOVERS = cfg['MISC']['write_leftovers']