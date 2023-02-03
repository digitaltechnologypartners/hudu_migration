import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()

DB_CON_STR = os.getenv('DB_CON_STR')
GLUE_EXPT_PATH = os.getenv('GLUE_EXPT_PATH')

for file in os.listdir(GLUE_EXPT_PATH):
    if file.endswith(".csv"):
        df = pd.read_csv(open(GLUE_EXPT_PATH + '/' + file))
        tablename = os.path.splitext(file)[0]
        engine = create_engine(DB_CON_STR)
        connection = engine.connect().execution_options(isolation_level="AUTOCOMMIT")
        df.to_sql(tablename,con=connection,if_exists='replace',index=False)
        print(file + ' OK')

