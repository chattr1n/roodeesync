from driver import Driver
import pandas as pd
from datetime import datetime, timedelta


class ClassTeachers:

    @staticmethod
    def get_mongo(SchoolName):
        row_list = []
        db = Driver.get_mongo(SchoolName)
        results = db['app-classes'].find({},{'id': 1, 'teachers':1})
        for result in results:
            row_dict = {}
            row_dict['ClassID'] = result['_id']
            teachers = result['teachers']
            for teacher in teachers:
                row_dict['TeacherID'] = teacher['value']
                row_list.append(row_dict)
        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):
        return Driver.get_mssql(SchoolName, 'exec spClassTeachersGet')

    @staticmethod
    def diff(df1, df2):

        key_column = 'ID'

        # insert and delete
        insert_df = df1[~df1[key_column].isin(df2[key_column])].copy()
        delete_df = df2[~df2[key_column].isin(df1[key_column])].copy()

        return [insert_df, delete_df]

    @staticmethod
    def Insert(SchoolName, upsert_df):

        sql_list = []
        for index, row in upsert_df.iterrows():
            ClassID = row['ClassID']
            TeacherID = row['TeacherID']

            sql_list.append('exec spClassTeachersInsert @ClassID="' + ClassID + '", @TeacherID="' + TeacherID + '"')

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def delete(SchoolName, delete_df):

        sql_list = []
        for index, row in delete_df.iterrows():
            ClassID = row['ClassID']
            TeacherID = row['TeacherID']

            sql_list.append('exec spClassTeachersDelete @ClassID="' + ClassID + '", @TeacherID="' + TeacherID + '"')

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = ClassTeachers.get_mongo(SchoolName)
        df2 = ClassTeachers.get_mssql(SchoolName)

        df1['ID'] = df1['ClassID'] + '|' + df1['TeacherID']
        df2['ID'] = df2['ClassID'] + '|' + df2['TeacherID']

        [insert_df, delete_df] = ClassTeachers.diff(df1, df2)

        ClassTeachers.Insert(SchoolName, insert_df)
        ClassTeachers.delete(SchoolName, delete_df)

        return [len(insert_df), -1, len(delete_df)]