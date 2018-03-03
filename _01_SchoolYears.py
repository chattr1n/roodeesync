from driver import Driver
import pandas as pd

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
            row_dict['BeginDate'] = result['beginDate']
            row_dict['EndDate'] = result['endDate']
            row_list.append(row_dict)

        return pd.DataFrame(row_list)
        
    
    @staticmethod
    def get_mssql():
        
        sql = 'exec spSchoolYearsGet'
        return Driver.get_mssql(sql)
    
    @staticmethod
    def diff(df1, df2):
        
        key_column = 'ID'
        
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        update_df = df1[df1[key_column].isin(df2[key_column])].copy()        

        return [insert_df, update_df]
    
    
    @staticmethod
    def upsert(upsert_df):
        
        pass
    
    @staticmethod
    def delete(delete_df):
        
        pass
    
    @staticmethod
    def run():
        
        df1 = SchoolYears.get_mongo()
        df2 = SchoolYears.get_mssql()
        
        [insert_df, update_df] = SchoolYears.diff(df1, df2)
        
        print(insert_df)
        print('----------------------------------')
        print(update_df)