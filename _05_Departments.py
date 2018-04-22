from driver import Driver
import pandas as pd
from datetime import datetime, timedelta

class Departments:
    
    @staticmethod
    def get_mongo(SchoolName):
        row_list = []
        
        db = Driver.get_mongo(SchoolName)
        results = db['app-department'].find({})

        for result in results:
            row_dict = {}
            row_dict['ID'] = result['_id']
            row_dict['Name'] = result['name']
            row_dict['NameTH'] = result['th']['name']  
            
            row_list.append(row_dict)

        return pd.DataFrame(row_list)            
        
    
    @staticmethod
    def get_mssql(SchoolName):
        
        return Driver.get_mssql(SchoolName, 'exec spDepartmentsGet')
    
    @staticmethod
    def diff(df1, df2):
        key_column = 'ID'

        # insert and delete
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        # update
        d1 = df1[df1[key_column].isin(df2[key_column])].copy()
        d1.set_index(['ID'], inplace=True)
        d1.sort_index(inplace=True)

        d2 = df2[df2[key_column].isin(df1[key_column])].copy()
        d2.set_index(['ID'], inplace=True)
        d2.sort_index(inplace=True)

        update_df = pd.DataFrame(data=None, columns=d1.columns, index=d1.index)

        # d1 will have the same row count as d2
        if len(d1) > 0:
            update_df = d1[~(
                (d1['Name'] == d2['Name'])
                & (d1['NameTH'] == d2['NameTH'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]
    
    
    @staticmethod
    def upsert(SchoolName, upsert_df, Method):

        params = []
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            Name = row['Name']
            NameTH = row['NameTH']

            params.append((ID, Name, NameTH))
                        
        Driver.upsert_or_delete_mssql(SchoolName, 'spDepartments' + Method, params)
        
    
    @staticmethod
    def delete(SchoolName, delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql(SchoolName, 'spDepartmentsDelete', params)
    
    @staticmethod
    def run(SchoolName):
        pd.set_option('display.width', 1000)
        
        df1 = Departments.get_mongo(SchoolName)
        df2 = Departments.get_mssql(SchoolName)
        
        [insert_df, update_df, delete_df] = Departments.diff(df1, df2)
                    
        Departments.upsert(SchoolName, insert_df, 'Insert')
        Departments.upsert(SchoolName, update_df, 'Update')
        Departments.delete(SchoolName, delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]