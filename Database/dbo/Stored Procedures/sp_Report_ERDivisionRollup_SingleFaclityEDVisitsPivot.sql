
CREATE PROCEDURE [dbo].[sp_Report_ERDivisionRollup_SingleFaclityEDVisitsPivot]
	(
		@coid VARCHAR(5),
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		[1] AS jan, 
		[2] AS feb, 
		[3] AS mar, 
		[4] AS apr, 
		[5] AS may, 
		[6] AS jun, 
		[7] AS jul, 
		[8] AS aug, 
		[9] AS sep, 
		[10] AS oct, 
		[11] AS nov, 
		[12] AS DEC
	FROM 
		(
			SELECT month_of_discharge_date, COUNT(1) AS visits
			FROM ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND year_of_discharge_date = @year
			GROUP BY month_of_discharge_date
		) AS SourceTable
	PIVOT
		(
			SUM(visits)
			FOR month_of_discharge_date IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
		) AS PivotTable;
END

