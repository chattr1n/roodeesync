from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class Classes:
    @staticmethod
    def get_mongo():

        row_list = []

        db = Driver.get_mongo()
        results = db['app-classes'].find({})

        for result in results:
            row_dict = {}
            row_dict['ID'] = result['_id']
            row_dict['Name'] = result['classDetail']['name']
            row_dict['NameTH'] = result['classDetail']['th']['name']
            row_dict['Building'] = result['classDetail']['building']
            row_dict['BuildingTH'] = result['classDetail']['th']['building']
            row_dict['Room'] = result['classDetail']['room']
            row_dict['RoomTH'] = result['classDetail']['th']['room']
            row_dict['Credits'] = result['classDetail']['credits']
            row_dict['MissedAllow'] = result['classDetail']['missedAllow']
            row_dict['SubjectID'] = result['subject']
            row_dict['SchoolYearID'] = result['schoolYear']
            row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql():

        return Driver.get_mssql('exec spClassesGet')

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
                & (d1['Building'] == d2['Building'])
                & (d1['BuildingTH'] == d2['BuildingTH'])
                & (d1['Room'] == d2['Room'])
                & (d1['RoomTH'] == d2['RoomTH'])
                & (d1['Credits'] == d2['Credits'])
                & (d1['MissedAllow'] == d2['MissedAllow'])
                & (d1['SubjectID'] == d2['SubjectID'])
                & (d1['SchoolYearID'] == d2['SchoolYearID'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]

    @staticmethod
    def upsert(upsert_df):
        params = []
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            Name = row['Name']
            NameTH = row['NameTH']
            Building = row['Building']
            BuildingTH = row['BuildingTH']
            Room = row['Room']
            RoomTH = row['RoomTH']
            Credits = row['Credits']
            MissedAllow = row['MissedAllow']
            SubjectID = row['SubjectID']
            SchoolYearID = row['SchoolYearID']

            params.append((ID, Name, NameTH, Building, BuildingTH, Room, RoomTH, Credits, MissedAllow, SubjectID, SchoolYearID))

        Driver.upsert_or_delete_mssql('spClassesUpsert', params)

    @staticmethod
    def delete(delete_df):
        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql('spClassesDelete', params)

    @staticmethod
    def run():

        pd.set_option('display.width', 1000)

        df1 = Classes.get_mongo()
        df2 = Classes.get_mssql()

        [insert_df, update_df, delete_df] = Classes.diff(df1, df2)

        Classes.upsert(insert_df)
        Classes.upsert(update_df)
        Classes.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]