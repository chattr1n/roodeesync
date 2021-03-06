/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.3023)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/


/****** Object:  Table [dbo].[Attendances]    Script Date: 4/1/2018 7:15:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Attendances](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [varchar](50) NULL,
	[StudentID] [varchar](50) NULL,
	[Status] [int] NULL,
	[PeriodDT] [datetime] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Classes]    Script Date: 4/1/2018 7:15:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Classes](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Building] [nvarchar](100) NULL,
	[BuildingTH] [nvarchar](100) NULL,
	[Room] [nvarchar](100) NULL,
	[RoomTH] [nvarchar](100) NULL,
	[Credits] [nvarchar](10) NULL,
	[MissedAllow] [nvarchar](10) NULL,
	[SubjectID] [varchar](50) NULL,
	[SchoolYearID] [varchar](50) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ClassPeriods]    Script Date: 4/1/2018 7:15:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClassPeriods](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [varchar](50) NULL,
	[ClassDay] [varchar](10) NULL,
	[ClassBegin] [datetime] NULL,
	[ClassEnd] [datetime] NULL,
	[created] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ClassStudents]    Script Date: 4/1/2018 7:15:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClassStudents](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [varchar](50) NOT NULL,
	[StudentID] [varchar](50) NOT NULL,
	[Created] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ClassTeachers]    Script Date: 4/1/2018 7:15:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClassTeachers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [varchar](50) NOT NULL,
	[TeacherID] [varchar](50) NOT NULL,
	[Created] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Departments]    Script Date: 4/1/2018 7:15:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Departments](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Generations]    Script Date: 4/1/2018 7:15:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Generations](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_Generations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[GradeCat]    Script Date: 4/1/2018 7:15:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GradeCat](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Color] [varchar](10) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Grades]    Script Date: 4/1/2018 7:15:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Grades](
	[ID] [varchar](100) NOT NULL,
	[ClassID] [varchar](50) NULL,
	[Name] [nvarchar](200) NULL,
	[FullScore] [nvarchar](10) NULL,
	[AssignedDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[GradeCat] [varchar](50) NULL,
	[Announced] [bit] NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Parents]    Script Date: 4/1/2018 7:15:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Parents](
	[ID] [varchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Username] [nvarchar](200) NULL,
	[Name] [nvarchar](200) NULL,
	[Middlename] [nvarchar](200) NULL,
	[Surname] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[MiddlenameTH] [nvarchar](200) NULL,
	[SurNameTH] [nvarchar](200) NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PeriodList]    Script Date: 4/1/2018 7:15:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PeriodList](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Color] [varchar](10) NULL,
	[BeginDT] [datetime] NULL,
	[EndDT] [datetime] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SchoolYears]    Script Date: 4/1/2018 7:15:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SchoolYears](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[StudentGrades]    Script Date: 4/1/2018 7:15:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StudentGrades](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudentID] [varchar](50) NULL,
	[GradeID] [varchar](100) NULL,
	[Score] [nvarchar](10) NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[StudentParents]    Script Date: 4/1/2018 7:15:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StudentParents](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudentID] [varchar](50) NOT NULL,
	[ParentID] [varchar](50) NOT NULL,
	[Created] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Students]    Script Date: 4/1/2018 7:15:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Students](
	[ID] [varchar](50) NOT NULL,
	[GenerationID] [varchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Username] [nvarchar](200) NULL,
	[Name] [nvarchar](200) NULL,
	[Middlename] [nvarchar](200) NULL,
	[Surname] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[MiddlenameTH] [nvarchar](200) NULL,
	[SurNameTH] [nvarchar](200) NULL,
	[StudentNo] [nvarchar](50) NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Subjects]    Script Date: 4/1/2018 7:15:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Subjects](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Code] [nvarchar](50) NULL,
	[DepartmentID] [varchar](50) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TaskListCat]    Script Date: 4/1/2018 7:15:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TaskListCat](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[Color] [varchar](10) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Teachers]    Script Date: 4/1/2018 7:15:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Teachers](
	[ID] [varchar](50) NOT NULL,
	[Username] [nvarchar](200) NULL,
	[Email] [nvarchar](50) NULL,
	[Name] [nvarchar](200) NULL,
	[Middlename] [nvarchar](200) NULL,
	[Surname] [nvarchar](200) NULL,
	[NameTH] [nvarchar](200) NULL,
	[MiddlenameTH] [nvarchar](200) NULL,
	[SurNameTH] [nvarchar](200) NULL,
	[TeacherNo] [nvarchar](50) NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


 CREATE NONCLUSTERED INDEX IX_Students1 ON dbo.Students (  GenerationID ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Students_Username ON dbo.Students (  Username ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Students_Name ON dbo.Students (  Name ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_ClassStudents ON dbo.ClassStudents (  ClassID ASC  , StudentID ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_ClassTeachers ON dbo.ClassTeachers (  ClassID ASC  , TeacherID ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Attendances ON dbo.Attendances (  ClassID ASC  , StudentID ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Attendances2 ON dbo.Attendances (  PeriodDT ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_ClassPeriods1 ON dbo.ClassPeriods (  ClassID ASC  ) --  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Parents_Username ON dbo.Parents (  Username ASC  ) --  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Parents_Name ON dbo.Parents (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Departments_Name ON dbo.Departments (  Name ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Generations_Name ON dbo.Generations (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_GradeCat_Name ON dbo.GradeCat (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_PeriodList_Name ON dbo.PeriodList (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Studentparents ON dbo.StudentParents (  StudentID ASC  , ParentID ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_SchoolYears_Name ON dbo.SchoolYears (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Subjects_DepartmentID ON dbo.Subjects (  DepartmentID ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Subjects_Name ON dbo.Subjects (  Name ASC  ) --  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_TaskListCat_Name ON dbo.TaskListCat (  Name ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Grades1 ON dbo.Grades (  ClassID ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Grades_Name ON dbo.Grades (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_StudentGrades1 ON dbo.StudentGrades (  StudentID ASC  , GradeID ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Classes1 ON dbo.Classes (  SubjectID ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Classes2 ON dbo.Classes (  SchoolYearID ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Classes_Name ON dbo.Classes (  Name ASC  )  -- WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Teachers_Username ON dbo.Teachers (  Username ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_Teachers_Name ON dbo.Teachers (  Name ASC  )   --WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
