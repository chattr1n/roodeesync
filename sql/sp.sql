/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.3023)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

/****** Object:  StoredProcedure [dbo].[sp_GenerateIndex]    Script Date: 4/1/2018 7:20:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_GenerateIndex]
as

SELECT ' CREATE ' + 
    CASE WHEN I.is_unique = 1 THEN ' UNIQUE ' ELSE '' END  +  
    I.type_desc COLLATE DATABASE_DEFAULT +' INDEX ' +   
    I.name  + ' ON '  +  
    Schema_name(T.Schema_id)+'.'+T.name + ' ( ' + 
    KeyColumns + ' )  ' + 
    ISNULL(' INCLUDE ('+IncludedColumns+' ) ','') + 
    ISNULL(' WHERE  '+I.Filter_definition,'') + ' WITH ( ' + 
    CASE WHEN I.is_padded = 1 THEN ' PAD_INDEX = ON ' ELSE ' PAD_INDEX = OFF ' END + ','  + 
    'FILLFACTOR = '+CONVERT(CHAR(5),CASE WHEN I.Fill_factor = 0 THEN 100 ELSE I.Fill_factor END) + ','  + 
    -- default value 
    'SORT_IN_TEMPDB = OFF '  + ','  + 
    CASE WHEN I.ignore_dup_key = 1 THEN ' IGNORE_DUP_KEY = ON ' ELSE ' IGNORE_DUP_KEY = OFF ' END + ','  + 
    CASE WHEN ST.no_recompute = 0 THEN ' STATISTICS_NORECOMPUTE = OFF ' ELSE ' STATISTICS_NORECOMPUTE = ON ' END + ','  + 
    -- default value  
    ' DROP_EXISTING = ON '  + ','  + 
    -- default value  
    ' ONLINE = OFF '  + ','  + 
   CASE WHEN I.allow_row_locks = 1 THEN ' ALLOW_ROW_LOCKS = ON ' ELSE ' ALLOW_ROW_LOCKS = OFF ' END + ','  + 
   CASE WHEN I.allow_page_locks = 1 THEN ' ALLOW_PAGE_LOCKS = ON ' ELSE ' ALLOW_PAGE_LOCKS = OFF ' END  + ' ) ON [' + 
   DS.name + ' ] '  [CreateIndexScript] 
FROM sys.indexes I   
 JOIN sys.tables T ON T.Object_id = I.Object_id    
 JOIN sys.sysindexes SI ON I.Object_id = SI.id AND I.index_id = SI.indid   
 JOIN (SELECT * FROM (  
    SELECT IC2.object_id , IC2.index_id ,  
        STUFF((SELECT ' , ' + C.name + CASE WHEN MAX(CONVERT(INT,IC1.is_descending_key)) = 1 THEN ' DESC ' ELSE ' ASC ' END 
    FROM sys.index_columns IC1  
    JOIN Sys.columns C   
       ON C.object_id = IC1.object_id   
       AND C.column_id = IC1.column_id   
       AND IC1.is_included_column = 0  
    WHERE IC1.object_id = IC2.object_id   
       AND IC1.index_id = IC2.index_id   
    GROUP BY IC1.object_id,C.name,index_id  
    ORDER BY MAX(IC1.key_ordinal)  
       FOR XML PATH('')), 1, 2, '') KeyColumns   
    FROM sys.index_columns IC2   
    --WHERE IC2.Object_id = object_id('Person.Address') --Comment for all tables  
    GROUP BY IC2.object_id ,IC2.index_id) tmp3 )tmp4   
  ON I.object_id = tmp4.object_id AND I.Index_id = tmp4.index_id  
 JOIN sys.stats ST ON ST.object_id = I.object_id AND ST.stats_id = I.index_id   
 JOIN sys.data_spaces DS ON I.data_space_id=DS.data_space_id   
 JOIN sys.filegroups FG ON I.data_space_id=FG.data_space_id   
 LEFT JOIN (SELECT * FROM (   
    SELECT IC2.object_id , IC2.index_id ,   
        STUFF((SELECT ' , ' + C.name  
    FROM sys.index_columns IC1   
    JOIN Sys.columns C    
       ON C.object_id = IC1.object_id    
       AND C.column_id = IC1.column_id    
       AND IC1.is_included_column = 1   
    WHERE IC1.object_id = IC2.object_id    
       AND IC1.index_id = IC2.index_id    
    GROUP BY IC1.object_id,C.name,index_id   
       FOR XML PATH('')), 1, 2, '') IncludedColumns    
   FROM sys.index_columns IC2    
   --WHERE IC2.Object_id = object_id('Person.Address') --Comment for all tables   
   GROUP BY IC2.object_id ,IC2.index_id) tmp1   
   WHERE IncludedColumns IS NOT NULL ) tmp2    
ON tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id   
WHERE I.is_primary_key = 0 AND I.is_unique_constraint = 0 
--AND I.Object_id = object_id('Person.Address') --Comment for all tables 
--AND I.name = 'IX_Address_PostalCode' --comment for all indexes 
GO

/****** Object:  StoredProcedure [dbo].[sp_PopulateColumns]    Script Date: 4/1/2018 7:20:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_PopulateColumns]
	@tablename varchar(100)
as

select	case when c.xtype = 231 then 'cast(' + c.name + ' as nvarchar(' + cast(prec as varchar) + ')) as ' + c.name + ',' -- + char(13)
	else c.name + ',' end
from	sysobjects o
	inner join syscolumns c on c.ID = o.ID
where	o.name = @tablename
order by colorder

GO

/****** Object:  StoredProcedure [dbo].[sp_ResetTables]    Script Date: 4/1/2018 7:20:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_ResetTables]
as

select	'truncate table ' + name
from	sysobjects
where	xtype = 'U'
order by 1
GO

/****** Object:  StoredProcedure [dbo].[spAttendancesDelete]    Script Date: 4/1/2018 7:20:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spAttendancesDelete]
	@ClassID varchar(50),
	@StudentID varchar(50)
as

delete from Attendances where ClassID = @ClassID and StudentID = @StudentID
GO

/****** Object:  StoredProcedure [dbo].[spAttendancesGet]    Script Date: 4/1/2018 7:20:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spAttendancesGet]
as

select	ClassID, StudentID, Status, PeriodDT from Attendances
GO

/****** Object:  StoredProcedure [dbo].[spAttendancesInsert]    Script Date: 4/1/2018 7:20:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spAttendancesInsert]
	@ClassID varchar(50),
	@StudentID nvarchar(50),
	@Status int,
	@PeriodDT datetime
as

insert into Attendances
(
	ClassID,
	StudentID,
	Status,
	PeriodDT,
	created,
	updated
)
select	@ClassID,
	@StudentID,
	@Status,
	@PeriodDT,
	getutcdate(),
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spAttendancesUpdate]    Script Date: 4/1/2018 7:20:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spAttendancesUpdate]
	@ClassID varchar(50),
	@StudentID nvarchar(50),
	@Status int,
	@PeriodDT datetime
as

update	Attendances
set	Status = @Status,	
	Updated = getutcdate()
where	ClassID = @ClassID
	and StudentID = @StudentID
	and PeriodDT = @PeriodDT

GO

/****** Object:  StoredProcedure [dbo].[spClassesDelete]    Script Date: 4/1/2018 7:20:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spClassesDelete]
	@ID varchar(50)
as

delete from Classes where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spClassesGet]    Script Date: 4/1/2018 7:20:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spClassesGet]
as

select	ID,
	cast(Name as nvarchar(200)) as Name, 
	cast(NameTH as nvarchar(200)) as NameTH, 
	cast(Building as nvarchar(100)) as Building, 
	cast(BuildingTH as nvarchar(100)) as BuildingTH, 
	cast(Room as nvarchar(100)) as Room, 
	cast(RoomTH as nvarchar(100)) as RoomTH, 
	SubjectID,
	SchoolYearID
from	Classes

GO

/****** Object:  StoredProcedure [dbo].[spClassesInsert]    Script Date: 4/1/2018 7:20:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spClassesInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Building nvarchar(100),
	@BuildingTH nvarchar(100),
	@Room nvarchar(100),
	@RoomTH nvarchar(100),
	@SubjectID varchar(50),
	@SchoolYearID varchar(50)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Building = isnull(@Building, ''),
	@BuildingTH = isnull(@BuildingTH, ''),
	@Room = isnull(@Room, ''),
	@RoomTH = isnull(@RoomTH, ''),
	@SubjectID = isnull(@SubjectID, ''),
	@SchoolYearID = isnull(@SchoolYearID, '')

insert into Classes
(
	ID,
	Name,
	NameTH,
	Building,
	BuildingTH,
	Room,
	RoomTH,
	SubjectID,
	SchoolYearID,
	created,
	updated
)
select	@ID,
	@Name,
	@NameTH,
	@Building,
	@BuildingTH,
	@Room,
	@RoomTH,
	@SubjectID,
	@SchoolYearID,
	getutcdate(),
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spClassesUpdate]    Script Date: 4/1/2018 7:20:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spClassesUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Building nvarchar(100),
	@BuildingTH nvarchar(100),
	@Room nvarchar(100),
	@RoomTH nvarchar(100),
	@SubjectID varchar(50),
	@SchoolYearID varchar(50)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Building = isnull(@Building, ''),
	@BuildingTH = isnull(@BuildingTH, ''),
	@Room = isnull(@Room, ''),
	@RoomTH = isnull(@RoomTH, ''),
	@SubjectID = isnull(@SubjectID, ''),
	@SchoolYearID = isnull(@SchoolYearID, '')

update	Classes
set	Name = @Name,
	NameTH = @NameTH,
	Building = @Building,
	BuildingTH = @BuildingTH,
	Room = @Room,
	RoomTH = @RoomTH,
	SubjectID = @SubjectID,
	SchoolYearID = @SchoolYearID,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spClassPeriodsDelete]    Script Date: 4/1/2018 7:20:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spClassPeriodsDelete]
	@ID int
as

delete from ClassPeriods 
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spClassPeriodsGet]    Script Date: 4/1/2018 7:20:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spClassPeriodsGet]
as

select	ID,
	ClassID,
	ClassDay,
	ClassBegin,
	ClassEnd
from	ClassPeriods
GO

/****** Object:  StoredProcedure [dbo].[spClassPeriodsInsert]    Script Date: 4/1/2018 7:20:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spClassPeriodsInsert]
	@ClassID varchar(50),
	@ClassDay varchar(10),
	@ClassBegin datetime,
	@ClassEnd datetime
as

insert into ClassPeriods
(
	ClassID,
	ClassDay,
	ClassBegin,
	ClassEnd,
	created
)
select	@ClassID,
	@ClassDay,
	@ClassBegin,
	@ClassEnd,
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spClassStudentsDelete]    Script Date: 4/1/2018 7:20:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spClassStudentsDelete]
	@ClassID varchar(50),
	@StudentID varchar(50)
as

delete from ClassStudents where ClassID = @ClassID and StudentID = @StudentID
GO

/****** Object:  StoredProcedure [dbo].[spClassStudentsGet]    Script Date: 4/1/2018 7:20:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spClassStudentsGet]
as

select	ClassID, StudentID
from	ClassStudents

GO

/****** Object:  StoredProcedure [dbo].[spClassStudentsInsert]    Script Date: 4/1/2018 7:20:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spClassStudentsInsert]
	@ClassID varchar(50),
	@StudentID nvarchar(50)	
as

insert into ClassStudents
(
	ClassID,
	StudentID,
	created
)
select	@ClassID,
	@StudentID,
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spClassTeachersDelete]    Script Date: 4/1/2018 7:20:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spClassTeachersDelete]
	@ClassID varchar(50),
	@TeacherID varchar(50)
as

delete from ClassTeachers where ClassID = @ClassID and TeacherID = @TeacherID
GO

/****** Object:  StoredProcedure [dbo].[spClassTeachersGet]    Script Date: 4/1/2018 7:21:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spClassTeachersGet]
as

select	ClassID, TeacherID
from	ClassTeachers

GO

/****** Object:  StoredProcedure [dbo].[spClassTeachersInsert]    Script Date: 4/1/2018 7:21:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spClassTeachersInsert]
	@ClassID varchar(50),
	@TeacherID nvarchar(50)	
as

insert into ClassTeachers
(
	ClassID,
	TeacherID,
	created
)
select	@ClassID,
	@TeacherID,
	getutcdate()
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsDelete]    Script Date: 4/1/2018 7:21:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spDepartmentsDelete]
	@ID varchar(50)
as

delete from Departments where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsGet]    Script Date: 4/1/2018 7:21:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spDepartmentsGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as  Name, 
	cast(NameTH as nvarchar(200)) as  NameTH 
from	Departments

GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsInsert]    Script Date: 4/1/2018 7:21:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spDepartmentsInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, '')


insert into Departments
(
	ID,
	Name,
	NameTH,
	created,
	updated
)
select	@ID,
	@Name,
	@NameTH,
	getutcdate(),
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsUpdate]    Script Date: 4/1/2018 7:21:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spDepartmentsUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, '')

update	Departments
set	Name = @Name,
	NameTH = @NameTH,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGenerationsDelete]    Script Date: 4/1/2018 7:21:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spGenerationsDelete]
	@ID varchar(50)
as

delete from Generations where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGenerationsGet]    Script Date: 4/1/2018 7:21:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spGenerationsGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as  Name, 
	cast(NameTH as nvarchar(200)) as  NameTH
from	Generations
GO

/****** Object:  StoredProcedure [dbo].[spGenerationsInsert]    Script Date: 4/1/2018 7:21:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spGenerationsInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, '')


insert into Generations
(
	ID,
	Name,
	NameTH
)
select	@ID,
	@Name,
	@NameTH
GO

/****** Object:  StoredProcedure [dbo].[spGenerationsUpdate]    Script Date: 4/1/2018 7:21:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spGenerationsUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, '')

update	GradeCat
set	Name = @Name,
	NameTH = @NameTH
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGradeCatDelete]    Script Date: 4/1/2018 7:21:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spGradeCatDelete]
	@ID varchar(50)
as

delete from GradeCat where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGradeCatGet]    Script Date: 4/1/2018 7:21:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spGradeCatGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as  Name,
	cast(NameTH as nvarchar(200)) as  NameTH,
	Color
from	GradeCat
GO

/****** Object:  StoredProcedure [dbo].[spGradeCatInsert]    Script Date: 4/1/2018 7:21:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spGradeCatInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, '')


insert into GradeCat
(
	ID,
	Name,
	NameTH,
	Color
)
select	@ID,
	@Name,
	@NameTH,
	@Color
GO

/****** Object:  StoredProcedure [dbo].[spGradeCatUpdate]    Script Date: 4/1/2018 7:21:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spGradeCatUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, '')


update	GradeCat
set	Name = @Name,
	NameTH = @NameTH,
	Color = @Color
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGradesDelete]    Script Date: 4/1/2018 7:21:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spGradesDelete]
	@ID varchar(100)
as

delete	from Grades
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spGradesGet]    Script Date: 4/1/2018 7:21:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spGradesGet]
as

select	ID,
	ClassID,
	cast(Name as nvarchar(200)) as Name,
	cast(FullScore as nvarchar(200)) as FullScore,
	AssignedDate,
	DueDate,
	GradeCat,
	Announced
from	Grades

GO

/****** Object:  StoredProcedure [dbo].[spGradesInsert]    Script Date: 4/1/2018 7:21:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spGradesInsert]
	@ID varchar(100),
	@ClassID varchar(50),
	@Name nvarchar(200),
	@FullScore nvarchar(10),
	@AssignedDate datetime,
	@DueDate datetime,
	@GradeCat varchar(50),
	@Announced bit
as

insert into Grades
(
	ID,
	ClassID,
	Name,
	FullScore,
	AssignedDate,
	DueDate,
	GradeCat,
	Announced
)
select	@ID,
	@ClassID,
	@Name,
	@FullScore,
	@AssignedDate,
	@DueDate,
	@GradeCat,
	@Announced
GO

/****** Object:  StoredProcedure [dbo].[spGradesUpdate]    Script Date: 4/1/2018 7:21:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spGradesUpdate]
	@ID varchar(100),
	@ClassID varchar(50),
	@Name nvarchar(200),
	@FullScore nvarchar(10),
	@AssignedDate datetime,
	@DueDate datetime,
	@GradeCat varchar(50),
	@Announced bit
as


update	Grades
set	ClassID = @ClassID,
	Name = @Name,
	FullScore = @FullScore,
	AssignedDate = @AssignedDate,
	DueDate = @DueDate,
	GradeCat = @GradeCat,
	Announced = @Announced
where	ID = @ID

GO

/****** Object:  StoredProcedure [dbo].[spParentsDelete]    Script Date: 4/1/2018 7:21:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spParentsDelete]
	@ID varchar(50)
as

delete from Parents where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spParentsGet]    Script Date: 4/1/2018 7:21:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spParentsGet]
as

select	ID,
	cast(Username as nvarchar(200)) as Username,
	cast(Email as nvarchar(50)) as Email,
	cast(Name as nvarchar(200)) as Name,
	cast(Middlename as nvarchar(200)) as Middlename,
	cast(Surname as nvarchar(200)) as Surname,	
	cast(NameTH as nvarchar(200)) as NameTH,
	cast(MiddlenameTH as nvarchar(200)) as MiddlenameTH,
	cast(SurNameTH as nvarchar(200)) as SurNameTH
from	Parents
GO

/****** Object:  StoredProcedure [dbo].[spParentsInsert]    Script Date: 4/1/2018 7:21:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spParentsInsert]
	@ID varchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200)
as

select	@ID = isnull(@ID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, '')

insert into Parents
(
	ID,	
	Username,
	Email,
	Name,
	Middlename,
	Surname,		
	NameTH,
	MiddlenameTH,
	SurNameTH,
	created,
	updated
)
select	@ID,
	@Username,
	@Email,
	@Name,
	@Middlename,
	@Surname,		
	@NameTH,
	@MiddlenameTH,
	@SurNameTH,
	getutcdate(),
	getutcdate()
GO

/****** Object:  StoredProcedure [dbo].[spParentsUpdate]    Script Date: 4/1/2018 7:21:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spParentsUpdate]
	@ID varchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200)
as

select	@ID = isnull(@ID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, '')

update	Parents
set	Username = @Username,
	Email = @Email,
	Name = @Name,
	Middlename = @Middlename,
	Surname = @Surname,		
	NameTH = @NameTH,
	MiddlenameTH = @MiddlenameTH,
	SurNameTH = @SurNameTH,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spPeriodListDelete]    Script Date: 4/1/2018 7:21:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spPeriodListDelete]
	@ID varchar(50)
as

delete from PeriodList where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spPeriodListGet]    Script Date: 4/1/2018 7:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spPeriodListGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as Name, 
	cast(NameTH as nvarchar(200)) as  NameTH,
	Color,
	BeginDT,
	EndDT
from	PeriodList
GO

/****** Object:  StoredProcedure [dbo].[spPeriodListInsert]    Script Date: 4/1/2018 7:21:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spPeriodListInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10),
	@BeginDT datetime,
	@EndDT datetime
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, ''),
	@BeginDT = isnull(@BeginDT, '1900-01-01 00:00.00'),
	@EndDT = isnull(@EndDT, '1900-01-01 00:00.00')

insert into PeriodList
(
	ID,
	Name,
	NameTH,
	Color,
	BeginDT,
	EndDT,
	created,
	updated
)
select	@ID,
	@Name,
	@NameTH,
	@Color,
	@BeginDT,
	@EndDT,
	getutcdate(),
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spPeriodListUpdate]    Script Date: 4/1/2018 7:21:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spPeriodListUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10),
	@BeginDT datetime,
	@EndDT datetime
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, ''),
	@BeginDT = isnull(@BeginDT, '1900-01-01 00:00.00'),
	@EndDT = isnull(@EndDT, '1900-01-01 00:00.00')


update	PeriodList
set	Name = @Name,
	NameTH = @NameTH,
	Color = @Color,
	BeginDT = @BeginDT,
	EndDT = @EndDT,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsDelete]    Script Date: 4/1/2018 7:21:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spSchoolYearsDelete]
	@ID varchar(50)
as

delete from SchoolYears where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsGet]    Script Date: 4/1/2018 7:21:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[spSchoolYearsGet]
as

select	ID,
	cast(Name as nvarchar(200)) as Name,
	cast(NameTH as nvarchar(200)) as NameTH,
	BeginDate,
	EndDate
from	SchoolYears

GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsInsert]    Script Date: 4/1/2018 7:21:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spSchoolYearsInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@BeginDate datetime,
	@EndDate datetime
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@BeginDate = isnull(@BeginDate, '1900-01-01 00:00.00'),
	@EndDate = isnull(@EndDate, '1900-01-01 00:00.00')

insert into SchoolYears
(
	ID,
	Name,
	NameTH,
	BeginDate,
	EndDate,
	created,
	updated
)
select	@ID,
	@Name,
	@NameTH,
	@BeginDate,
	@EndDate,
	getutcdate(),
	getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsUpdate]    Script Date: 4/1/2018 7:21:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spSchoolYearsUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@BeginDate datetime,
	@EndDate datetime
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@BeginDate = isnull(@BeginDate, '1900-01-01 00:00.00'),
	@EndDate = isnull(@EndDate, '1900-01-01 00:00.00')

update	SchoolYears
set	Name = @Name,
	NameTH = NameTH,
	BeginDate = BeginDate,
	EndDate = EndDate,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spStudentGradesDelete]    Script Date: 4/1/2018 7:21:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spStudentGradesDelete]
	@StudentID varchar(50),
	@GradeID varchar(100)
as

delete from StudentGrades 
where	StudentID = @StudentID
	and GradeID = @GradeID
GO

/****** Object:  StoredProcedure [dbo].[spStudentGradesGet]    Script Date: 4/1/2018 7:21:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spStudentGradesGet]
as

select	ID, 
	StudentID,
	GradeID,
	cast(Score as nvarchar(10)) as Score
from	StudentGrades
GO

/****** Object:  StoredProcedure [dbo].[spStudentGradesInsert]    Script Date: 4/1/2018 7:21:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spStudentGradesInsert]
	@StudentID varchar(50),
	@GradeID varchar(100),
	@Score nvarchar(10)
as

insert into StudentGrades
(
	StudentID,
	GradeID,
	Score,
	created,
	updated
)
select	@StudentID,
	@GradeID,
	@Score,
	getutcdate(),
	getutcdate()
GO

/****** Object:  StoredProcedure [dbo].[spStudentGradesUpdate]    Script Date: 4/1/2018 7:21:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spStudentGradesUpdate]
	@StudentID varchar(50),
	@GradeID varchar(100),
	@Score nvarchar(10)
as

update	StudentGrades
set	Score = @Score
where	StudentID = @StudentID
	and GradeID = @GradeID
GO

/****** Object:  StoredProcedure [dbo].[spStudentParentsDelete]    Script Date: 4/1/2018 7:21:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spStudentParentsDelete]
	@StudentID varchar(50),
	@ParentID varchar(50)
as

delete from StudentParents
where	StudentID = @StudentID
	and ParentID = @ParentID

GO

/****** Object:  StoredProcedure [dbo].[spStudentParentsGet]    Script Date: 4/1/2018 7:21:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spStudentParentsGet]
as

select	StudentID, ParentID
from	StudentParents

GO

/****** Object:  StoredProcedure [dbo].[spStudentParentsInsert]    Script Date: 4/1/2018 7:21:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[spStudentParentsInsert]
	@StudentID varchar(50),
	@ParentID varchar(50)
as

insert into StudentParents (StudentID, ParentID, Created)
select	@StudentID, @ParentID, getutcdate()

GO

/****** Object:  StoredProcedure [dbo].[spStudentsDelete]    Script Date: 4/1/2018 7:21:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spStudentsDelete]
	@ID varchar(50)
as

delete from Students where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spStudentsGet]    Script Date: 4/1/2018 7:21:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spStudentsGet]
as

select	ID,
	GenerationID,
	cast(Username as nvarchar(200)) as Username,
	cast(Email as nvarchar(50)) as Email,
	cast(Name as nvarchar(200)) as Name,
	cast(Middlename as nvarchar(200)) as Middlename,
	cast(Surname as nvarchar(200)) as Surname,	
	cast(NameTH as nvarchar(200)) as NameTH,
	cast(MiddlenameTH as nvarchar(200)) as MiddlenameTH,
	cast(SurNameTH as nvarchar(200)) as SurNameTH,
	cast(StudentNo as nvarchar(50)) as StudentNo
from	Students
GO

/****** Object:  StoredProcedure [dbo].[spStudentsInsert]    Script Date: 4/1/2018 7:21:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spStudentsInsert]
	@ID varchar(50),
	@GenerationID varchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200),
	@StudentNo nvarchar(50)
as

select	@ID = isnull(@ID, ''),
	@GenerationID = isnull(@GenerationID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, ''),
	@StudentNo = isnull(@StudentNo, '')

insert into Students
(
	ID,
	GenerationID,		
	Username,
	Email,
	Name,
	Middlename,
	Surname,		
	NameTH,
	MiddlenameTH,
	SurNameTH,
	StudentNo,
	created,
	updated
)
select	@ID,
	@GenerationID,
	@Username,
	@Email,
	@Name,
	@Middlename,
	@Surname,		
	@NameTH,
	@MiddlenameTH,
	@SurNameTH,
	@StudentNo,
	getutcdate(),
	getutcdate()
GO

/****** Object:  StoredProcedure [dbo].[spStudentsUpdate]    Script Date: 4/1/2018 7:21:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spStudentsUpdate]
	@ID varchar(50),
	@GenerationID varchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200),
	@StudentNo nvarchar(50)
as

select	@ID = isnull(@ID, ''),
	@GenerationID = isnull(@GenerationID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, ''),
	@StudentNo = isnull(@StudentNo, '')

update	Students
set	GenerationID = @GenerationID,
	Username = @Username,
	Email = @Email,
	Name = @Name,
	Middlename = @Middlename,
	Surname = @Surname,		
	NameTH = @NameTH,
	MiddlenameTH = @MiddlenameTH,
	SurNameTH = @SurNameTH,
	StudentNo = @StudentNo,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spSubjectsDelete]    Script Date: 4/1/2018 7:21:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spSubjectsDelete]
	@ID varchar(50)
as

delete from Subjects where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spSubjectsGet]    Script Date: 4/1/2018 7:21:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spSubjectsGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as Name, 
	cast(NameTH as nvarchar(200)) as  NameTH,
	cast(Code as nvarchar(50)) as Code,
	DepartmentID
from	Subjects
GO

/****** Object:  StoredProcedure [dbo].[spSubjectsInsert]    Script Date: 4/1/2018 7:21:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spSubjectsInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Code nvarchar(50),
	@DepartmentID varchar(100)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Code = isnull(@Code, ''),
	@DepartmentID = isnull(@DepartmentID, '')


insert into Subjects
(
	ID,
	Name,
	NameTH,
	Code,
	DepartmentID,
	created,
	updated
)
select	@ID,
	@Name,
	@NameTH,
	@Code,
	@DepartmentID,
	getutcdate(),
	getutcdate()
GO

/****** Object:  StoredProcedure [dbo].[spSubjectsUpdate]    Script Date: 4/1/2018 7:21:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spSubjectsUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Code nvarchar(50),
	@DepartmentID varchar(100)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Code = isnull(@Code, ''),
	@DepartmentID = isnull(@DepartmentID, '')


update	Subjects
set	Name = @Name,
	NameTH = @NameTH,
	Code = @Code,
	DepartmentID = @DepartmentID,
	updated = getutcdate()
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spTaskListCatDelete]    Script Date: 4/1/2018 7:21:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spTaskListCatDelete]
	@ID varchar(50)
as

delete from TaskListCat where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spTaskListCatGet]    Script Date: 4/1/2018 7:21:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[spTaskListCatGet]
as

select	ID, 
	cast(Name as nvarchar(200)) as Name, 
	cast(NameTH as nvarchar(200)) as  NameTH,
	Color
from	TaskListCat
GO

/****** Object:  StoredProcedure [dbo].[spTaskListCatInsert]    Script Date: 4/1/2018 7:21:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spTaskListCatInsert]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, '')

insert into TaskListCat
(
	ID,
	Name,
	NameTH,
	Color
)
select	@ID,
	@Name,
	@NameTH,
	@Color
GO

/****** Object:  StoredProcedure [dbo].[spTaskListCatUpdate]    Script Date: 4/1/2018 7:21:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spTaskListCatUpdate]
	@ID varchar(50),
	@Name nvarchar(200),
	@NameTH nvarchar(200),
	@Color varchar(10)
as

select	@Name = isnull(@Name, ''),
	@NameTH = isnull(@NameTH, ''),
	@Color = isnull(@Color, '')

update	TaskListCat
set	Name = @Name,
	NameTH = @NameTH,
	Color = @Color
where	ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spTeachersDelete]    Script Date: 4/1/2018 7:21:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[spTeachersDelete]
	@ID varchar(50)
as

delete from Teachers where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spTeachersGet]    Script Date: 4/1/2018 7:21:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spTeachersGet]
as

select	ID,
	cast(Username as nvarchar(200)) as Username, 
	cast(Email as nvarchar(50)) as Email, 
	cast(Name as nvarchar(200)) as Name, 
	cast(Middlename as nvarchar(200)) as Middlename, 
	cast(Surname as nvarchar(200)) as Surname, 		
	cast(NameTH as nvarchar(200)) as NameTH, 
	cast(MiddlenameTH as nvarchar(200)) as MiddlenameTH, 
	cast(SurNameTH as nvarchar(200)) as SurNameTH,
	cast(TeacherNo as nvarchar(200)) as TeacherNo	
from	Teachers

GO

/****** Object:  StoredProcedure [dbo].[spTeachersInsert]    Script Date: 4/1/2018 7:21:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spTeachersInsert]
	@ID nvarchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200),
	@TeacherNo nvarchar(50)
as

select	@ID = isnull(@ID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),	
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, ''),
	@TeacherNo = isnull(@TeacherNo, '')	

insert into Teachers
(
	ID,
	Username,
	Email,
	Name,
	Middlename,
	Surname,		
	NameTH,
	MiddlenameTH,
	SurNameTH,
	TeacherNo,
	Created,
	Updated
)
select	@ID,
	@Username,
	@Email,
	@Name,
	@Middlename,
	@Surname,
	@NameTH,
	@MiddlenameTH,
	@SurNameTH,
	@TeacherNo,
	getutcdate(),
	getutcdate()


GO

/****** Object:  StoredProcedure [dbo].[spTeachersUpdate]    Script Date: 4/1/2018 7:21:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spTeachersUpdate]
	@ID nvarchar(50),
	@Username nvarchar(200),
	@Email nvarchar(50),
	@Name nvarchar(200),
	@Middlename nvarchar(200),
	@Surname nvarchar(200),	
	@NameTH nvarchar(200),
	@MiddlenameTH nvarchar(200),
	@SurNameTH nvarchar(200),
	@TeacherNo nvarchar(50)
as

select	@ID = isnull(@ID, ''),
	@Username = isnull(@Username, ''),
	@Email = isnull(@Email, ''),
	@Name = isnull(@Name, ''),
	@Middlename = isnull(@Middlename, ''),
	@Surname = isnull(@Surname, ''),	
	@NameTH = isnull(@NameTH, ''),
	@MiddlenameTH = isnull(@MiddlenameTH, ''),
	@SurNameTH = isnull(@SurNameTH, ''),
	@TeacherNo = isnull(@TeacherNo, '')	

update	Teachers
set	Username = @Username,
	Email = @Email,
	Name = @Name,
	Middlename = @Middlename,
	Surname = @Surname,		
	NameTH = @NameTH,
	MiddlenameTH = @MiddlenameTH,
	SurNameTH = @SurNameTH,
	TeacherNo = @TeacherNo,
	updated = getutcdate()
where	ID = @ID
GO


