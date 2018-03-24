from driver import Driver
import pandas as pd
import numpy as np
import datetime


class Grades:

    @staticmethod
    def get_mongo():

        row_list = []

        db = Driver.get_mongo()
        results = db['app-classes'].find({}, {'grades':1})

        for result in results:
            ClassID = result['_id']
            grades = result['grades']
            for grade in grades:

                ID = grade['_id'] if '_id' in grade.keys() else grade['GradeID'] + ClassID
                name = grade['name'] if 'name' in grade.keys() else ''
                fullscore = str(grade['fullscore']) if 'fullscore' in grade.keys() else ''
                assignDate = str(grade['assignDate'])[:19] if 'assignDate' in grade.keys() else ''
                dueDate = str(grade['dueDate'])[:19] if 'dueDate' in grade.keys() else ''
                cat = grade['cat'] if 'cat' in grade.keys() else ''
                isAnnounce = grade['isAnnouce']  if 'isAnnouce' in grade.keys() else False

                row_dict = {}
                row_dict['ID'] = ID
                row_dict['ClassID'] = ClassID
                row_dict['Name'] = name
                row_dict['FullScore'] = fullscore
                row_dict['AssignedDate'] = assignDate
                row_dict['DueDate'] = dueDate
                row_dict['GradeCat'] = cat
                row_dict['Announced'] = isAnnounce
                row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql():
        return Driver.get_mssql('exec spGradesGet')

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
                & (d1['Name'] == d2['Name'])
                & (d1['FullScore'] == d2['FullScore'])
                & (d1['AssignedDate'] == d2['AssignedDate'].astype(str))
                & (d1['DueDate'] == d2['DueDate'].astype(str))
                & (d1['GradeCat'] == d2['GradeCat'])
                & (d1['Announced'] == d2['Announced'])
            )]

        update_df.reset_index(inplace=True)

        return [insert_df, update_df, delete_df]

    @staticmethod
    def format_datetime(dt):

        if pd.isnull(dt):
            return datetime.datetime(1900, 1, 1, 0, 0, 0)
        if str(type(dt)) == "<class 'str'>":
            return datetime.datetime(1900, 1, 1, 0, 0, 0)
        if str(type(dt)) == "<class 'datetime.datetime'>":
            return dt

        # at this point, it's probably timestamp datatype
        return dt.to_pydatetime()

    @staticmethod
    def upsert(upsert_df, Method):

        '''
        @ID varchar(50),
        @ClassID varchar(50),
        @Name nvarchar(200),
        @FullScore nvarchar(10),
        @AssignedDate datetime,
        @DueDate datetime,
        @GradeCat varchar(50),
        @Announced bit
        '''

        sql_list = []
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            ClassID = row['ClassID']
            Name = row['Name']
            FullScore = row['FullScore']
            AssignedDate = row['AssignedDate']
            DueDate = row['DueDate']
            GradeCat = row['GradeCat']
            Announced = row['Announced']

            sql = 'exec spGrades' + Method + ' '
            sql += '@ID="' + ID + '",'
            sql += '@ClassID="' + ClassID + '",'
            sql += '@Name="' + Name + '",'
            sql += '@FullScore="' + str(FullScore) + '",'
            sql += '@AssignedDate="' + AssignedDate + '",'
            sql += '@DueDate="' + DueDate + '",'
            sql += '@GradeCat="' + GradeCat + '",'
            sql += '@Announced=' + str(Announced)
            sql_list.append(sql)

        Driver.executemany(sql_list)


    @staticmethod
    def delete(delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql('spGradesDelete', params)

    @staticmethod
    def run():

        pd.set_option('display.width', 1000)

        df1 = Grades.get_mongo()
        df2 = Grades.get_mssql()

        [insert_df, update_df, delete_df] = Grades.diff(df1, df2)

        Grades.upsert(insert_df, 'Insert')
        Grades.upsert(update_df, 'Update')
        Grades.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]