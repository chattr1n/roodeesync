from driver import Driver
import pandas as pd
import datetime

class ClassPeriods:

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
        results = db['app-classes'].find({}, {"periods":1})

        for result in results:
            ClassID = result['_id']
            periods = result['periods']
            for period in periods:
                row_dict = {}
                row_dict['ClassID'] = ClassID
                row_dict['ClassDay'] = period['day']
                row_dict['ClassBegin'] = str(period['begin'])[:19].replace('T', ' ')
                row_dict['ClassEnd'] = str(period['end'])[:19].replace('T', ' ')
                row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):

        return Driver.get_mssql(SchoolName, 'exec spClassPeriodsGet')

    @staticmethod
    def diff(df1, df2):

        key_column = 'key'

        df1[key_column] = df1['ClassID'] + df1['ClassDay'] + df1['ClassBegin'].astype(str) + df1['ClassEnd'].astype(str)
        df2[key_column] = df2['ClassID'] + df2['ClassDay'] + df2['ClassBegin'].astype(str) + df2['ClassEnd'].astype(str)

        # insert and delete
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        return [insert_df, delete_df]

    @staticmethod
    def insert(SchoolName, insert_df):
        sql_list = []
        for index, row in insert_df.iterrows():
            ClassID = row['ClassID']
            ClassDay = row['ClassDay']
            ClassBegin = row['ClassBegin']
            ClassEnd = row['ClassEnd']

            sql = 'exec spClassPeriodsInsert '
            sql += '@ClassID="' + ClassID + '",'
            sql += '@ClassDay="' + ClassDay + '",'
            sql += '@ClassBegin="' + ClassBegin + '",'
            sql += '@ClassEnd="' + ClassEnd + '"'
            sql_list.append(sql)

        Driver.executemany(SchoolName, sql_list)


    @staticmethod
    def delete(SchoolName, delete_df):
        sql_list = []
        for index, row in delete_df.iterrows():
            ID = row['ID']

            sql = 'exec spClassPeriodsDelete '
            sql += '@ID=' + str(ID) + ''
            sql_list.append(sql)

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = ClassPeriods.get_mongo(SchoolName)
        df2 = ClassPeriods.get_mssql(SchoolName)

        [insert_df, delete_df] = ClassPeriods.diff(df1, df2)

        ClassPeriods.insert(SchoolName, insert_df)
        ClassPeriods.delete(SchoolName, delete_df)

        return [len(insert_df), -1, len(delete_df)]