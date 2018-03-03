if not exists (select null from sysobjects where name = 'SchoolYears')
begin
	create table SchoolYears
	(
		ID varchar(100) primary key,
		Name nvarchar(100),
		NameTH nvarchar(100),
		BeginDate datetime,
		EndDate datetime,
		Created datetime,
		Updated datetime
	)
end