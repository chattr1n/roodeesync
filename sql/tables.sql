USE [roodee-dev]
GO

/****** Object:  Table [dbo].[SchoolYears]    Script Date: 3/5/2018 2:12:02 AM ******/
DROP TABLE [dbo].[SchoolYears]
GO

/****** Object:  Table [dbo].[Departments]    Script Date: 3/5/2018 2:12:02 AM ******/
DROP TABLE [dbo].[Departments]
GO

/****** Object:  Table [dbo].[Departments]    Script Date: 3/5/2018 2:12:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Departments](
	[ID] [varchar](100) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[NameTH] [nvarchar](100) NULL,
	[created] [datetime] NULL,
	[updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

/****** Object:  Table [dbo].[SchoolYears]    Script Date: 3/5/2018 2:12:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SchoolYears](
	[ID] [varchar](100) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[NameTH] [nvarchar](100) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO


