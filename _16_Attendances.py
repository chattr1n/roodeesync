from driver import Driver
import pandas as pd
import datetime

class Attendances:

    '''
    @staticmethod
    def format_datetime(dt):

        # probably in pandas timestamp
        if str(type(dt)) != "<class 'datetime.datetime'>":
            return dt.to_pydatetime().strftime('%Y%m%d%H%M%S')
        else:
            return dt.strftime('%Y%m%d%H%M%S')
    '''

    @staticmethod
    def get_mongo(SchoolName):

        row_list = []
        db = Driver.get_mongo(SchoolName)
        results = db['app-classes'].find({}, {"attendances":1})

        for result in results:
            ClassID = result['_id']
            attendances = result['attendances']
            for attendance in attendances:
                PeriodDT = attendance['periodDate']
                studentState = attendance['studentState']
                for student in studentState:
                    row_dict = {}
                    row_dict['ClassID'] = ClassID
                    row_dict['StudentID'] = student['student']
                    row_dict['PeriodDT'] = PeriodDT
                    row_dict['Status'] = student['status']

                    if row_dict['Status'] != 1:
                        row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):

        return Driver.get_mssql(SchoolName, 'exec spAttendancesGet')

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
                (d1['ClassID'] == d2['ClassID'])
                & (d1['StudentID'] == d2['StudentID'])
                & (d1['PeriodDT'] == d2['PeriodDT'])
                & (d1['Status'] == d2['Status'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]

    @staticmethod
    def upsert(SchoolName, upsert_df, method):
        sql_list = []
        for index, row in upsert_df.iterrows():
            ClassID = row['ClassID']
            StudentID = row['StudentID']
            PeriodDT = row['PeriodDT']
            Status = row['Status']

            sql = 'exec spAttendances' + method + ' '
            sql += '@ClassID="' + ClassID + '",'
            sql += '@StudentID="' + StudentID + '",'
            sql += '@PeriodDT="' + str(PeriodDT.to_pydatetime()) + '",'
            sql += '@Status=' + str(Status)
            sql_list.append(sql)

        Driver.executemany(SchoolName, sql_list)


    @staticmethod
    def delete(SchoolName, delete_df):
        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql(SchoolName, 'spAttendancesDelete', params)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = Attendances.get_mongo(SchoolName)
        df2 = Attendances.get_mssql(SchoolName)

        df1['ID'] = df1['ClassID'] + '|' + df1['StudentID'] + '|' + df1['PeriodDT'].astype(str)
        df2['ID'] = df2['ClassID'] + '|' + df2['StudentID'] + '|' + df2['PeriodDT'].astype(str)

        [insert_df, update_df, delete_df] = Attendances.diff(df1, df2)

        Attendances.upsert(SchoolName, insert_df, 'Insert')
        Attendances.upsert(SchoolName, update_df, 'Update')
        Attendances.delete(SchoolName, delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]