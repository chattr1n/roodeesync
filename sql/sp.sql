
if exists (select null from sysobjects where name = 'spSchoolYearsUpsert')
	drop proc spSchoolYearsUpsert
go

create proc spSchoolYearsUpsert
	@SchoolID varchar(50),
	@SchoolName nvarchar(100),
	@SchoolNameTh nvarchar(100),
	@BeginDate datetime,
	@EndDate datetime
as

if exists
(
	select	null
	from	SchoolYears
	where	SchoolID = @SchoolID
		and SchoolName = @SchoolName
		and SchoolNameTh = @SchoolNameTh
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
	where	SchoolID = @SchoolID
)
begin
	update	SchoolYears
	set	SchoolName = @SchoolName,
		SchoolNameTh = @SchoolNameTh,
		BeginDate = @BeginDate,
		EndDate = @EndDate,
		updated = getutcdate()
	where	SchoolID = @SchoolID
end

-- update
else
begin
	insert into SchoolYears
	(
		SchoolID,
		SchoolName,
		SchoolNameTh,
		BeginDate,
		EndDate,
		created,
		updated
	)
	select	@SchoolID,
		@SchoolName,
		@SchoolNameTh,
		@BeginDate,
		@EndDate,
		getutcdate(),
		getutcdate()
end

go


if exists (select null from sysobjects where name = 'spSchoolYearsGet')
	drop proc spSchoolYearsGet
go

create proc spSchoolYearsGet
as

select * from SchoolYears

go