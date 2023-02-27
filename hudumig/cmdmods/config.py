import os
import pandas as pd
from configparser import ConfigParser
from hudumig.utils import getExportDB
from hudumig.settings import DEFAULT_CONFIG_PATH

cfg = ConfigParser()
cfg.read(DEFAULT_CONFIG_PATH)

def loadExpDb(path):
    for file in os.listdir(path):
        if file.endswith(".csv"):
            df = pd.read_csv(open(path + '/' + file))
            tablename = os.path.splitext(file)[0]
            connection = getExportDB()
            df.to_sql(tablename,con=connection,if_exists='replace',index=False)
            print(file + ' OK')

def updateConfigVars(vars):
    for var in vars:
        for section in cfg.sections():
            if var[0].lower() in cfg.options(section):
                value = var[1]
                if ',' in value:
                    values = value.split(',')
                    value = ",\n".join(values)
                cfg.set(section,var[0].lower(),value)
                f = open(DEFAULT_CONFIG_PATH,'w')
                cfg.write(f)
                f.close()
                print('Updated config variable ' + var[0] + ' with value ' + var[1] + '.')
    