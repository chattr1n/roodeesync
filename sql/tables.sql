if not exists (select null from sysobjects where name = 'SchoolYears')
begin
	create table SchoolYears
	(
		SchoolID varchar(50) primary key,
		SchoolName nvarchar(100),
		SchoolNameTh nvarchar(100),
		BeginDate datetime,
		EndDate datetime
	)
end