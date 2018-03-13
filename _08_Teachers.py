from driver import Driver
import pandas as pd
import numpy as np
import datetime


class Teachers:
    @staticmethod
    def get_mongo():

        row_list = []

        db = Driver.get_mongo()
        results = db['users'].find({"roles": "teacher"})

        for result in results:
            row_dict = {}

            row_dict['ID'] = result['_id']
            row_dict['Username'] = result['username']

            userProfile = result['userProfile']
            row_dict['Name'] = userProfile['name'] if 'name' in userProfile.keys() else ''
            row_dict['Middlename'] = userProfile['middlename'] if 'middlename' in userProfile.keys() else ''
            row_dict['Surname'] = userProfile['surname'] if 'surname' in userProfile.keys() else ''
            row_dict['NickName'] = userProfile['nickname'] if 'nickname' in userProfile.keys() else ''
            row_dict['DateOfBirth'] = Teachers.format_datetime(userProfile['dateOfBirth']) if 'dateOfBirth' in userProfile.keys() else datetime.datetime(1900, 1, 1, 0, 0, 0)
            row_dict['Gender'] = userProfile['gender'] if 'gender' in userProfile.keys() else ''
            row_dict['Religion'] = userProfile['religion'] if 'religion' in userProfile.keys() else ''
            row_dict['BloodType'] = userProfile['bloodType'] if 'bloodType' in userProfile.keys() else ''
            row_dict['MedicalHistory'] = userProfile['medicalHistory'] if 'medicalHistory' in userProfile.keys() else ''
            row_dict['Address'] = userProfile['address'] if 'address' in userProfile.keys() else ''
            row_dict['MobilePhone'] = userProfile['mobilePhone'] if 'mobilePhone' in userProfile.keys() else ''
            row_dict['Email'] = userProfile['email'] if 'email' in userProfile.keys() else ''
            row_dict['Education'] = userProfile['education'] if 'education' in userProfile.keys() else ''
            row_dict['SchoolID'] = userProfile['idSchool'] if 'idSchool' in userProfile.keys() else ''
            row_dict['Photo'] = userProfile['photo'] if 'photo' in userProfile.keys() else ''
            row_dict['NationalID'] = userProfile['nationalNo'] if 'nationalNo' in userProfile.keys() else ''
            row_dict['Institution'] = userProfile['institution'] if 'institution' in userProfile.keys() else ''
            row_dict['GraduatedYear'] = userProfile['graduatedYear'] if 'graduatedYear' in userProfile.keys() else ''
            row_dict['EntryDate'] = Teachers.format_datetime(userProfile['entryDate']) if 'entryDate' in userProfile.keys() else datetime.datetime(1900, 1, 1, 0, 0, 0)
            row_dict['Nationality'] = userProfile['nationality'] if 'nationality' in userProfile.keys() else ''
            row_dict['ZipCode'] = userProfile['zipCode'] if 'zipCode' in userProfile.keys() else ''
            row_dict['Province'] = userProfile['province'] if 'province' in userProfile.keys() else ''
            row_dict['TeacherLicenseNo'] = userProfile['teacherLicenseNo'] if 'teacherLicenseNo' in userProfile.keys() else ''
            row_dict['ExprCertificationDate'] = Teachers.format_datetime(userProfile['exprCertificationDate']) if 'exprCertificationDate' in userProfile.keys() else datetime.datetime(1900, 1, 1, 0, 0, 0)

            userProfileTH = userProfile['th']
            row_dict['NameTH'] = userProfileTH['name'] if 'name' in userProfileTH.keys() else ''
            row_dict['MiddlenameTH'] = userProfileTH['middlename'] if 'middlename' in userProfileTH.keys() else ''
            row_dict['SurNameTH'] = userProfileTH['surname'] if 'surname' in userProfileTH.keys() else ''
            row_dict['NickNameTH'] = userProfileTH['nickname'] if 'nickname' in userProfileTH.keys() else ''

            row_list.append(row_dict)

        return pd.DataFrame(row_list)

    @staticmethod
    def get_mssql():

        return Driver.get_mssql('exec spTeachersGet')

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
                (d1['Username'] == d2['Username'])
                & (d1['Name'] == d2['Name'])
                & (d1['Middlename'] == d2['Middlename'])
                & (d1['Surname'] == d2['Surname'])
                & (d1['NickName'] == d2['NickName'])
                & (d1['DateOfBirth'] == d2['DateOfBirth'])
                & (d1['Gender'] == d2['Gender'])
                & (d1['Religion'] == d2['Religion'])
                & (d1['BloodType'] == d2['BloodType'])
                & (d1['MedicalHistory'] == d2['MedicalHistory'])
                & (d1['Address'] == d2['Address'])
                & (d1['MobilePhone'] == d2['MobilePhone'])
                & (d1['Email'] == d2['Email'])
                & (d1['Education'] == d2['Education'])
                & (d1['SchoolID'] == d2['SchoolID'])
                & (d1['Photo'] == d2['Photo'])
                & (d1['NationalID'] == d2['NationalID'])
                & (d1['Institution'] == d2['Institution'])
                & (d1['GraduatedYear'] == d2['GraduatedYear'])
                & (d1['EntryDate'] == d2['EntryDate'])
                & (d1['Nationality'] == d2['Nationality'])
                & (d1['ZipCode'] == d2['ZipCode'])
                & (d1['Province'] == d2['Province'])
                & (d1['TeacherLicenseNo'] == d2['TeacherLicenseNo'])
                & (d1['ExprCertificationDate'] == d2['ExprCertificationDate'])
                & (d1['NameTH'] == d2['NameTH'])
                & (d1['MiddlenameTH'] == d2['MiddlenameTH'])
                & (d1['SurNameTH'] == d2['SurNameTH'])
                & (d1['NickNameTH'] == d2['NickNameTH'])
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
            Username = row['Username']
            Name = row['Name']
            Middlename = row['Middlename']
            Surname = row['Surname']
            NickName = row['NickName']
            DateOfBirth = Teachers.format_datetime(row['DateOfBirth'])
            Gender = row['Gender']
            Religion = row['Religion']
            BloodType = row['BloodType']
            MedicalHistory = row['MedicalHistory']
            Address = row['Address']
            MobilePhone = row['MobilePhone']
            Email = row['Email']
            Education = row['Education']
            SchoolID = row['SchoolID']
            Photo = row['Photo']
            NationalID = row['NationalID']
            Institution = row['Institution']
            GraduatedYear = row['GraduatedYear']
            EntryDate = Teachers.format_datetime(row['EntryDate'])
            Nationality = row['Nationality']
            ZipCode = row['ZipCode']
            Province = row['Province']
            TeacherLicenseNo = row['TeacherLicenseNo']
            ExprCertificationDate = Teachers.format_datetime(row['ExprCertificationDate']) #.to_pydatetime()
            NameTH = row['NameTH']
            MiddlenameTH = row['MiddlenameTH']
            SurNameTH = row['SurNameTH']
            NickNameTH = row['NickNameTH']

            params.append(
                (
                    ID, Username, Name, Middlename, Surname, NickName, DateOfBirth,
                    Gender, Religion, BloodType, MedicalHistory, Address, MobilePhone,
                    Email, Education, SchoolID, Photo, NationalID, Institution,
                    GraduatedYear, EntryDate, Nationality, ZipCode, Province,
                    TeacherLicenseNo, ExprCertificationDate, NameTH, MiddlenameTH,
                    SurNameTH, NickNameTH
                )
            )

        Driver.upsert_or_delete_mssql('spTeachersUpsert', params)

    @staticmethod
    def delete(delete_df):

        params = []
        for index, row in delete_df.iterrows():
            ID = row['ID']
            params.append((ID,))

        Driver.upsert_or_delete_mssql('spTeachersDelete', params)

    @staticmethod
    def run():

        pd.set_option('display.width', 1000)

        df1 = Teachers.get_mongo()
        df2 = Teachers.get_mssql()

        [insert_df, update_df, delete_df] = Teachers.diff(df1, df2)

        Teachers.upsert(insert_df)
        Teachers.upsert(update_df)
        Teachers.delete(delete_df)

        return [len(insert_df), len(update_df), len(delete_df)]