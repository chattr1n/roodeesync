from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class PeriodList:
    @staticmethod
    def get_mongo(SchoolName):

        row_list = []

        db = Driver.get_mongo(SchoolName)
        results = db['app-periodlist'].find({})

        for result in results:
            row_dict = {}
            row_dict['ID'] = result['_id']
            row_dict['Name'] = result['name']
            row_dict['NameTH'] = result['th']['name']
            row_dict['Color'] = result['color'] if 'color' in result.keys() else ''
            row_dict['BeginDT'] = result['begin']
            row_dict['EndDT'] = result['end']
            row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):

        return Driver.get_mssql(SchoolName, 'exec spPeriodListGet')

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
                & (d1['BeginDT'] == d2['BeginDT'])
                & (d1['EndDT'] == d2['EndDT'])
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
            Color = row['Color']
            BeginDT = row['BeginDT']
            EndDT = row['EndDT']

            params.append((ID, Name, NameTH, Color, BeginDT.to_pydatetime(), EndDT.to_pydatetime()))

        Driver.upsert_or_delete_mssql(SchoolName, 'spPeriodList' + Method, params)

    @staticmethod
    def delete(SchoolName, delete_df):
        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql(SchoolName, 'spPeriodListDelete', params)

    @staticmethod
    def run(SchoolName, ):

        pd.set_option('display.width', 1000)

        df1 = PeriodList.get_mongo(SchoolName)
        df2 = PeriodList.get_mssql(SchoolName)

        [insert_df, update_df, delete_df] = PeriodList.diff(df1, df2)

        PeriodList.upsert(SchoolName, insert_df, 'Insert')
        PeriodList.upsert(SchoolName, update_df, 'Update')
        PeriodList.delete(SchoolName, delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]