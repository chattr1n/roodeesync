from driver import Driver
import pandas as pd
import datetime


class Students:
    @staticmethod
    def get_mongo():

        row_list = []

        db = Driver.get_mongo()
        results = db['users'].find({"roles": "teacher"})

        for result in results:
            row_dict = {}

            row_dict['ID'] = result['_id']
            row_dict['GenerationID'] = result['generation']
            row_dict['Username'] = result['username']

            userProfile = result['userProfile']
            row_dict['Name'] = userProfile['name'] if 'name' in userProfile.keys() else ''
            row_dict['Middlename'] = userProfile['middlename'] if 'middlename' in userProfile.keys() else ''
            row_dict['Surname'] = userProfile['surname'] if 'surname' in userProfile.keys() else ''
            row_dict['Email'] = userProfile['email'] if 'email' in userProfile.keys() else ''
            row_dict['StudentNo'] = userProfile['idSchool'] if 'idSchool' in userProfile.keys() else ''

            userProfileTH = userProfile['th']
            row_dict['NameTH'] = userProfileTH['name'] if 'name' in userProfileTH.keys() else ''
            row_dict['MiddlenameTH'] = userProfileTH['middlename'] if 'middlename' in userProfileTH.keys() else ''
            row_dict['SurNameTH'] = userProfileTH['surname'] if 'surname' in userProfileTH.keys() else ''

            row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql():

        return Driver.get_mssql('exec spStudentsGet')

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
                (d1['GenerationID'] == d2['GenerationID'])
                & (d1['Username'] == d2['Username'])
                & (d1['Email'] == d2['Email'])
                & (d1['Name'] == d2['Name'])
                & (d1['Middlename'] == d2['Middlename'])
                & (d1['Surname'] == d2['Surname'])
                & (d1['NameTH'] == d2['NameTH'])
                & (d1['MiddlenameTH'] == d2['MiddlenameTH'])
                & (d1['SurNameTH'] == d2['SurNameTH'])
                & (d1['StudentNo'] == d2['StudentNo'])
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
    def upsert(upsert_df):

        params = []
        for index, row in upsert_df.iterrows():
            ID = row['ID']
            GenerationID = row['GenerationID']
            Username = row['Username']
            Email = row['Email']
            Name = row['Name']
            Middlename = row['Middlename']
            Surname = row['Surname']
            NameTH = row['NameTH']
            MiddlenameTH = row['MiddlenameTH']
            SurNameTH = row['SurNameTH']
            StudentNo = row['StudentNo']

            params.append(
                (
                    ID, GenerationID, Username, Email,
                    Name, Middlename, Surname,
                    NameTH, MiddlenameTH, SurNameTH,
                    StudentNo
                )
            )

        Driver.upsert_or_delete_mssql('spStudentsUpsert', params)

    @staticmethod
    def delete(delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql('spStudentsDelete', params)

    @staticmethod
    def run():

        pd.set_option('display.width', 1000)

        df1 = Students.get_mongo()
        df2 = Students.get_mssql()

        [insert_df, update_df, delete_df] = Students.diff(df1, df2)

        Students.upsert(insert_df)
        Students.upsert(update_df)
        Students.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]