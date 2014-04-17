CREATE PROCEDURE [dbo].[sp_report_EDDivisionYTDByFacility]
	(
		@division_id INT,
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(4000);

	IF OBJECT_ID('tempdb..#edytd') IS NOT NULL
	begin 
		DROP TABLE #edytd;
	END;

	CREATE TABLE #edytd
		(
			coid VARCHAR(5),
			facility VARCHAR(50),
			MONTH INT,
			YEAR INT,
			er_daily_stats_definition_id INT,
			er_daily_stats_definition VARCHAR(100),
			VALUE decimal(18, 2)
		);

	INSERT INTO #edytd
		(
			coid,
			facility,
			month,
			year,
			er_daily_stats_definition_id,
			er_daily_stats_definition,
			value
		)
	SELECT 
		f.coid,
		f.NAME,
		MONTH_OF_DISCHARGE_DATE,
		YEAR_OF_DISCHARGE_DATE,
		15,
		(SELECT name FROM dbo.ER_DAILY_STATS_DEFINITION WHERE ER_DAILY_STATS_DEFINITION_ID = 15),
		COUNT(ed.coid)
	FROM division d WITH (NOLOCK)
		JOIN facility f WITH (NOLOCK)
			ON d.division_id = f.DIVISION_ID

		JOIN dbo.ER_MONTHLY_DATA ed WITH (NOLOCK)
			ON f.COID = ed.COID
	WHERE d.DIVISION_ID = @division_id
		AND ed.YEAR_OF_DISCHARGE_DATE = @year
	GROUP BY f.coid, f.name, ed.MONTH_OF_DISCHARGE_DATE, ed.YEAR_OF_DISCHARGE_DATE

	SELECT *
	FROM #edytd
	ORDER BY facility, month;
		
END;

