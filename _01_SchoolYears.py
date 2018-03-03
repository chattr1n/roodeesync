from driver import Driver
import pandas as pd
from datetime import datetime, timedelta

class SchoolYears:
    
    @staticmethod
    def get_mongo():
        
        row_list = []
        
        db = Driver.get_mongo()
        results = db['app-schoolyear'].find({})

        for result in results:
            row_dict = {}
            row_dict['ID'] = result['_id']
            row_dict['Name'] = result['name']
            row_dict['NameTH'] = result['th']['name']            
            row_dict['BeginDate'] = result['beginDate'] if 'beginDate' in result.keys() else datetime(1900, 1, 1, 0, 0)        
            row_dict['EndDate'] = result['endDate'] if 'endDate' in result.keys() else datetime(1900, 1, 1, 0, 0)
            row_list.append(row_dict)

        return pd.DataFrame(row_list)
        
    
    @staticmethod
    def get_mssql():
        
        return Driver.get_mssql('exec spSchoolYearsGet')
    
    @staticmethod
    def diff(df1, df2):
        
        key_column = 'ID'
        
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        update_df = df1[df1[key_column].isin(df2[key_column])].copy()        

        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        return [insert_df, update_df, delete_df]
    
    
    @staticmethod
    def upsert(upsert_df):
        
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            Name = row['Name']
            NameTH = row['NameTH']
            BeginDate = row['BeginDate'].to_pydatetime() + timedelta(hours=7)
            EndDate = row['EndDate'].to_pydatetime() + timedelta(hours=7)
                        
            Driver.upsert_mssql('spSchoolYearsUpsert', (ID, Name, NameTH, BeginDate, EndDate))
        
    
    @staticmethod
    def delete(delete_df):
        
        for index, row in delete_df.iterrows():
            ID = row['ID']
                        
            Driver.delete_mssql('spSchoolYearsDelete', (ID,))
    
    @staticmethod
    def run():
        
        pd.set_option('display.width', 1000)
        
        df1 = SchoolYears.get_mongo()
        df2 = SchoolYears.get_mssql()
        
        [insert_df, update_df, delete_df] = SchoolYears.diff(df1, df2)
                    
        SchoolYears.upsert(insert_df)
        SchoolYears.upsert(update_df)
        SchoolYears.delete(delete_df)