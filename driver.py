import json
import ssl
from pymongo import MongoClient
import pyodbc

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
        
        
    def get_mssql(sql):
        
        settings = Driver.load_settings()
        
        server = 'roodee.database.windows.net'
        database = 'roodee-demo'
        username = 'produser@roodee'
        password = '~Proding0001'
        driver= '{ODBC Driver 13 for SQL Server}'
        conn = pyodbc.connect('DRIVER='+driver+';PORT=1433;SERVER='+server+';PORT=1443;DATABASE='+database+';UID='+username+';PWD='+ password)



        #connectionstring = settings['MSSQL_connectionstring']
        #conn = pyodbc.connect('DRIVER={SQL Server};SERVER=roodee.database.windows.net,1433', user='produser@roodee', password='~Proding0001', database='roodee-demo')
        #conn.autocommit = True
        
        crsr = conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()
        while rows:
            print(rows)
        
        conn.close