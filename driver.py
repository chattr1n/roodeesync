import json
import ssl
from pymongo import MongoClient
import pymssql

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
        
        
    def get_mssql():

        settings = Driver.load_settings()
        server = settings['MSSQL_Server']
        username = settings['MSSQL_User']
        password = settings['MSSQL_Pass']
        dbname = settings['MSSQL_DBName']

        return pymssql.connect(server=server, user=username, password=password, database=dbname)
