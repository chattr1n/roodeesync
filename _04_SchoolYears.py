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
                & (d1['BeginDate'] == d2['BeginDate'])
                & (d1['EndDate'] == d2['EndDate'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]
    
    
    @staticmethod
    def upsert(upsert_df, Method):

        params = []
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            Name = row['Name']
            NameTH = row['NameTH']
            BeginDate = row['BeginDate'].to_pydatetime()
            EndDate = row['EndDate'].to_pydatetime()

            params.append((ID, Name, NameTH, BeginDate, EndDate))
                        
        Driver.upsert_or_delete_mssql('spSchoolYears' + Method, params)
        
    
    @staticmethod
    def delete(delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql('spSchoolYearsDelete', params)
    
    @staticmethod
    def run():
        
        pd.set_option('display.width', 1000)
        
        df1 = SchoolYears.get_mongo()
        df2 = SchoolYears.get_mssql()
        
        [insert_df, update_df, delete_df] = SchoolYears.diff(df1, df2)
                    
        SchoolYears.upsert(insert_df, 'Insert')
        SchoolYears.upsert(update_df, 'Update')
        SchoolYears.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]