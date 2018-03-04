USE [roodee-dev]
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsUpsert]    Script Date: 3/5/2018 2:10:48 AM ******/
DROP PROCEDURE [dbo].[spSchoolYearsUpsert]
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsGet]    Script Date: 3/5/2018 2:10:49 AM ******/
DROP PROCEDURE [dbo].[spSchoolYearsGet]
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsDelete]    Script Date: 3/5/2018 2:10:49 AM ******/
DROP PROCEDURE [dbo].[spSchoolYearsDelete]
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsUpsert]    Script Date: 3/5/2018 2:10:49 AM ******/
DROP PROCEDURE [dbo].[spDepartmentsUpsert]
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsGet]    Script Date: 3/5/2018 2:10:49 AM ******/
DROP PROCEDURE [dbo].[spDepartmentsGet]
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsDelete]    Script Date: 3/5/2018 2:10:49 AM ******/
DROP PROCEDURE [dbo].[spDepartmentsDelete]
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsDelete]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spDepartmentsDelete]
	@ID varchar(100)
as

delete from Departments where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsGet]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spDepartmentsGet]
as

select	ID,
	Name,
	cast(NameTH as nvarchar(100)) as  NameTH
from	Departments

GO

/****** Object:  StoredProcedure [dbo].[spDepartmentsUpsert]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[spDepartmentsUpsert]
	@ID varchar(100),
	@Name nvarchar(100),
	@NameTH nvarchar(100)
as

if exists
(
	select	null
	from	Departments
	where	ID = @ID
		and Name = @Name
		and NameTH = @NameTH
)
begin
	return
end

-- insert
if exists
(
	select	null
	from	Departments
	where	ID = @ID
)
begin
	update	Departments
	set	Name = @Name,
		NameTH = @NameTH,
		updated = getutcdate()
	where	ID = @ID
end

-- update
else
begin
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
end

GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsDelete]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spSchoolYearsDelete]
	@ID varchar(100)
as

delete from SchoolYears where ID = @ID
GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsGet]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spSchoolYearsGet]
as

select	ID,
	Name,
	cast(NameTH as nvarchar(100)) as NameTH,
	BeginDate,
	EndDate
from	SchoolYears

GO

/****** Object:  StoredProcedure [dbo].[spSchoolYearsUpsert]    Script Date: 3/5/2018 2:10:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spSchoolYearsUpsert]
	@ID varchar(100),
	@Name nvarchar(100),
	@NameTH nvarchar(100),
	@BeginDate datetime,
	@EndDate datetime
as

if exists
(
	select	null
	from	SchoolYears
	where	ID = @ID
		and Name = @Name
		and NameTH = @NameTH
		and BeginDate = @BeginDate
		and EndDate = @EndDate
)
begin
	return
end

-- insert
if exists
(
	select	null
	from	SchoolYears
	where	ID = @ID
)
begin
	update	SchoolYears
	set	Name = @Name,
		NameTH = @NameTH,
		BeginDate = @BeginDate,
		EndDate = @EndDate,
		updated = getutcdate()
	where	ID = @ID
end

-- update
else
begin
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
end

GO


