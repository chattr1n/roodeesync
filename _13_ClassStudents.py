from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class ClassStudents:

    @staticmethod
    def get_mongo():
        row_list = []
        db = Driver.get_mongo()
        results = db['app-classes'].find({},{'id': 1, 'Students':1})
        for result in results:
            row_dict = {}
            row_dict['ClassID'] = result['_id']
            Students = result['Students']
            for Student in Students:
                row_dict['StudentID'] = Student['value']
                row_list.append(row_dict)
        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql():
        return Driver.get_mssql('exec spClassStudentsGet')

    @staticmethod
    def diff(df1, df2):

        key_column = 'ID'

        # insert and delete
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        return [insert_df, delete_df]

    @staticmethod
    def upsert(upsert_df):

        params = []
        for index, row in upsert_df.iterrows():
            ClassID = row['ClassID']
            StudentID = row['StudentID']

            params.append((ClassID, StudentID))

        Driver.upsert_or_delete_mssql('spClassStudentsUpsert', params)

    @staticmethod
    def delete(delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ClassID = row['ClassID']
            StudentID = row['StudentID']

            params.append((ClassID, StudentID))

        Driver.upsert_or_delete_mssql('spClassStudentsDelete', params)

    @staticmethod
    def run():

        pd.set_option('display.width', 1000)

        df1 = ClassStudents.get_mongo()
        df2 = ClassStudents.get_mssql()

        df1['ID'] = df1['ClassID'] + '|' + df1['StudentID']
        df2['ID'] = df2['ClassID'] + '|' + df2['StudentID']

        [insert_df, delete_df] = ClassStudents.diff(df1, df2)

        ClassStudents.upsert(insert_df)
        ClassStudents.delete(delete_df)

        return [len(insert_df), -1, len(delete_df)]