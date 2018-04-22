from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class ClassStudents:

    @staticmethod
    def get_mongo(SchoolName):
        row_list = []
        db = Driver.get_mongo(SchoolName)
        results = db['app-classes'].find({},{'id': 1, 'students':1})
        for result in results:
            ClassID = result['_id']
            Students = result['students']
            for Student in Students:
                row_dict = {}
                row_dict['ClassID'] = ClassID
                row_dict['StudentID'] = Student['value']
                row_list.append(row_dict)
        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):
        return Driver.get_mssql(SchoolName, 'exec spClassStudentsGet')

    @staticmethod
    def diff(df1, df2):

        key_column = 'ID'

        # insert and delete
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        return [insert_df, delete_df]

    @staticmethod
    def upsert(SchoolName, upsert_df):

        sql_list = []
        for index, row in upsert_df.iterrows():
            ClassID = row['ClassID']
            StudentID = row['StudentID']

            sql_list.append('exec spClassStudentsInsert @ClassID="' + ClassID + '", @StudentID="' + StudentID + '"')

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def delete(SchoolName, delete_df):

        sql_list = []
        for index, row in delete_df.iterrows():
            ClassID = row['ClassID']
            StudentID = row['StudentID']

            sql_list.append('exec spClassStudentsDelete "' + ClassID + '", "' + StudentID + '"')

        Driver.executemany(SchoolName, sql_list)


    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = ClassStudents.get_mongo(SchoolName)
        df2 = ClassStudents.get_mssql(SchoolName)

        df1['ID'] = df1['ClassID'] + '|' + df1['StudentID']
        df2['ID'] = df2['ClassID'] + '|' + df2['StudentID']

        [insert_df, delete_df] = ClassStudents.diff(df1, df2)

        ClassStudents.upsert(SchoolName, insert_df)
        ClassStudents.delete(SchoolName, delete_df)

        return [len(insert_df), -1, len(delete_df)]