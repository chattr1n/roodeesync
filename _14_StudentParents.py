from driver import Driver
import pandas as pd

class StudentParents:

    @staticmethod
    def get_mongo(SchoolName):
        row_list = []
        db = Driver.get_mongo(SchoolName)
        results = db['users'].find({'roles':'student'},{'userProfile.parents':1})
        for result in results:
            StudentID = result['_id']
            userProfile = result['userProfile']
            if 'parents' in userProfile.keys():
                parents = userProfile['parents']
                for parent in parents:
                    row_dict = {}
                    row_dict['StudentID'] = StudentID
                    row_dict['ParentID'] = parent
                    row_list.append(row_dict)
        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql(SchoolName):
        return Driver.get_mssql(SchoolName, 'exec spStudentParentsGet')

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
            StudentID = row['StudentID']
            ParentID = row['ParentID']

            sql_list.append('exec spStudentParentsInsert @StudentID="' + StudentID + '", @ParentID="' + ParentID + '"')

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def delete(SchoolName, delete_df):

        sql_list = []
        for index, row in delete_df.iterrows():
            StudentID = row['StudentID']
            ParentID = row['ParentID']

            sql_list.append('exec spStudentParentsDelete @StudentID="' + StudentID + '", @ParentID="' + ParentID + '"')

        Driver.executemany(SchoolName, sql_list)

    @staticmethod
    def run(SchoolName):

        pd.set_option('display.width', 1000)

        df1 = StudentParents.get_mongo(SchoolName)
        df2 = StudentParents.get_mssql(SchoolName)

        df1['ID'] = df1['StudentID'] + '|' + df1['ParentID']
        df2['ID'] = df2['StudentID'] + '|' + df2['ParentID']

        [insert_df, delete_df] = StudentParents.diff(df1, df2)

        StudentParents.Insert(SchoolName, insert_df)
        StudentParents.delete(SchoolName, delete_df)

        return [len(insert_df), -1, len(delete_df)]