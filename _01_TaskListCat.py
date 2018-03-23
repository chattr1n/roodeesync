from driver import Driver
import pandas as pd
from datetime import datetime, timedelta

class TaskListCat:
    
    @staticmethod
    def get_mongo():
        
        row_list = []
        
        db = Driver.get_mongo()
        results = db['app-tasklistcat'].find({})

        for result in results:
            row_dict = {}
            row_dict['ID'] = result['_id']
            row_dict['Name'] = result['name']
            row_dict['NameTH'] = result['th']['name']            
            row_dict['Color'] = result['color']
            row_list.append(row_dict)

        return pd.DataFrame(row_list)
        
    
    @staticmethod
    def get_mssql():
        
        return Driver.get_mssql('exec spTaskListCatGet')
    
    @staticmethod
    def diff(df1, df2):
        
        key_column = 'ID'

        if len(df1.columns) == 0:
            df1 = pd.DataFrame(data=None, columns=df2.columns, index=df2.index)

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
                & (d1['Color'] == d2['Color'])
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
            Color = row['Color']

            params.append((ID, Name, NameTH, Color))

        Driver.upsert_or_delete_mssql('spTaskListCat' + Method, params)
        
    
    @staticmethod
    def delete(delete_df):
        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))
                        
        Driver.upsert_or_delete_mssql('spTaskListCatDelete', params)
    
    @staticmethod
    def run():
        
        pd.set_option('display.width', 1000)
        
        df1 = TaskListCat.get_mongo()
        df2 = TaskListCat.get_mssql()
        
        [insert_df, update_df, delete_df] = TaskListCat.diff(df1, df2)
                    
        TaskListCat.upsert(insert_df, 'Insert')
        TaskListCat.upsert(update_df, 'Update')
        TaskListCat.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]