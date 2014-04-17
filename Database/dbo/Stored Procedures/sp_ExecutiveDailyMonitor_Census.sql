CREATE PROCEDURE [dbo].[sp_ExecutiveDailyMonitor_Census]
	(
		@coid varchar(5),
		@month int,
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    select f.name, a.monthno, a.year, a.day, a.census
	from DailyCensus a with (nolock)
		join Facility f with (nolock)
			on a.coid = f.coid
	where a.coid = @coid
		and a.year = @year
		and a.monthno = @month
	order by a.day;
END

