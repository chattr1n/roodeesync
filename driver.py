import json
import ssl
from pymongo import MongoClient
import pymssql
import pandas as pd

class Driver:
    
    @staticmethod
    def load_settings():

        file = open('settings.json')
        content = file.read()
        return json.loads(content)
        
    @staticmethod
    def get_mongo():

        settings = Driver.load_settings()
        client = MongoClient(settings['MONGO_connectionstring'], ssl_cert_reqs=ssl.CERT_NONE)
        return client[settings['MONGO_database']]
        
    @staticmethod
    def get_mssql(sql):

        settings = Driver.load_settings()
        server = settings['MSSQL_Server']
        username = settings['MSSQL_User']
        password = settings['MSSQL_Pass']
        dbname = settings['MSSQL_DBName']

        conn = pymssql.connect(server=server, user=username, password=password, database=dbname)
         
        try:
            return pd.read_sql(sql, conn)
        finally:
            conn.close()
            
    @staticmethod
    def upsert_or_delete_mssql(proc, params):
        settings = Driver.load_settings()
        server = settings['MSSQL_Server']
        username = settings['MSSQL_User']
        password = settings['MSSQL_Pass']
        dbname = settings['MSSQL_DBName']

        with pymssql.connect(server, username, password, dbname) as conn:
            with conn.cursor(as_dict=True) as cursor:
                for index, param in enumerate(params):
                    cursor.callproc(proc, param)
                    if index % 10 == 0:
                        conn.commit()
                conn.commit()

