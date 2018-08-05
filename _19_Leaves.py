from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class Leaves:

    @staticmethod
    def get_mongo(SchoolName):

        row_list = []

        db = Driver.get_mongo(SchoolName)
        results = db['app-schoolyear'].find({}, {'leaves':1})

        for result in results:
            for semester in result['leaves']:
                for period in semester['periodArray']:
                    row_dict = {}
                    row_dict['SemesterID'] = period['semesterID']
                    row_dict['StudentID'] = period['studentID']
                    row_dict['ClassID'] = period['classID']
                    row_dict['PeriodDate'] = period['periodDate']
                    row_dict['Reason'] = period['reason']

                    this_type = type(period['type'])

                    if this_type.__name__ == 'dict':
                        row_dict['TypeValue'] = period['type']['value']
                        row_dict['TypeLabel'] = period['type']['label']
                    else:
                        row_dict['TypeValue'] = period['type']
                        row_dict['TypeLabel'] = period['type']

                    row_dict['ByID'] = period['byID']
                    row_dict['EntryDate'] = period['entryDate']
                    row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):

        return Driver.get_mssql(SchoolName, 'exec spLeavesGet')

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
                    (d1['Reason'] == d2['Reason'])
                    & (d1['TypeValue'] == d2['TypeValue'])
                    & (d1['TypeValue'] == d2['TypeValue'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]

    @staticmethod
    def upsert(SchoolName, upsert_df, Method):

        params = []
        for index, row in upsert_df.iterrows():
            SemesterID = row['SemesterID']
            StudentID = row['StudentID']
            ClassID = row['ClassID']
            PeriodDate = row['PeriodDate'].to_pydatetime()
            Reason = row['Reason']
            TypeValue = row['TypeValue']
            TypeLabel = row['TypeLabel']
            ByID = row['ByID']
            EntryDate = row['EntryDate'].to_pydatetime()

            params.append((SemesterID, StudentID, ClassID, PeriodDate, Reason, TypeValue, TypeLabel, ByID, EntryDate))

        Driver.upsert_or_delete_mssql(SchoolName, 'spLeaves' + Method, params)

    @staticmethod
    def delete(SchoolName, delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql(SchoolName, 'spLeavesDelete', params)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = Leaves.get_mongo(SchoolName)
        df2 = Leaves.get_mssql(SchoolName)

        df1['ID'] = df1['SemesterID'] + '|' + df1['StudentID'] + '|' + df1['ClassID'] + '|' + df1['PeriodDate'].dt.strftime('%Y%m%d%H%M%S')
        df2['ID'] = df2['SemesterID'] + '|' + df2['StudentID'] + '|' + df2['ClassID'] + '|' + df2['PeriodDate'].dt.strftime('%Y%m%d%H%M%S') if len(df2) > 0 else ''

        [insert_df, update_df, delete_df] = Leaves.diff(df1, df2)

        Leaves.upsert(SchoolName, insert_df, 'Insert')
        Leaves.upsert(SchoolName, update_df, 'Update')
        Leaves.delete(SchoolName, delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]