CREATE PROCEDURE [dbo].[sp_report_CountLeftDocsPerFacility] (@year int)
AS
BEGIN
	SET NOCOUNT ON;

    select f.coid, count(f.coid) as physicians_left
    from facility f with (nolock)
		join provider p with (nolock)
			on f.coid = p.coid
	where datepart(yyyy, p.left_date) = @year
	group by f.coid
END

