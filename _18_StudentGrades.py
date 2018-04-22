from driver import Driver
import pandas as pd
import datetime


class StudentGrades:

    @staticmethod
    def get_mongo(SchoolName):

        row_list = []

        db = Driver.get_mongo(SchoolName)
        results = db['app-classes'].find({}, {'grades':1})

        for result in results:
            ClassID = result['_id']
            for grade in result['grades']:
                GradeID = grade['_id'] if '_id' in grade.keys() else grade['GradeID'] + ClassID
                for record in grade['records']:
                    row_dict = {}
                    row_dict['GradeID'] = GradeID
                    row_dict['StudentID'] = record['studentID']
                    row_dict['Score'] = str(record['score'])
                    row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):
        return Driver.get_mssql(SchoolName, 'exec spStudentGradesGet')

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
                (d1['Score'] == d2['Score'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]

    @staticmethod
    def upsert(SchoolName, upsert_df, Method):

        sql_list = []
        for index, row in upsert_df.iterrows():
            StudentID = row['StudentID']
            GradeID = row['GradeID']
            Score = row['Score']

            sql = 'exec spStudentGrades' + Method + ' '
            sql += '@StudentID="' + StudentID + '",'
            sql += '@GradeID="' + GradeID + '",'
            sql += '@Score="' + Score + '"'
            sql_list.append(sql)

        Driver.executemany(SchoolName, sql_list)


    @staticmethod
    def delete(SchoolName, delete_df):

        params = []
        for index, row in delete_df.iterrows():
            StudentID = row['StudentID']
            GradeID = row['GradeID']
            params.append((StudentID, GradeID))

        Driver.upsert_or_delete_mssql(SchoolName, 'spStudentGradesDelete', params)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = StudentGrades.get_mongo(SchoolName)
        df2 = StudentGrades.get_mssql(SchoolName)

        df1['ID'] = df1['StudentID'] + '|' + df1['GradeID']
        df2['ID'] = df2['StudentID'] + '|' + df2['GradeID']

        [insert_df, update_df, delete_df] = StudentGrades.diff(df1, df2)

        StudentGrades.upsert(SchoolName, insert_df, 'Insert')
        StudentGrades.upsert(SchoolName, update_df, 'Update')
        StudentGrades.delete(SchoolName, delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]