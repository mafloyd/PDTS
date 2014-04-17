
CREATE PROCEDURE [dbo].[sp_report_Chart_DetailData_ByDivision]
	(
		@division_id INT,
		@er_stats_definition_id int,	
		@begin_month INT,
		@begin_year INT,
		@end_month INT,
		@end_year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT a.*,
		f.NAME AS facility,
		d.name AS division
	FROM dbo.ER_DAILY_ENTRY a WITH (NOLOCK)
		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.COID

		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
	WHERE f.DIVISION_ID = @division_id
		AND a.ER_DAILY_STATS_DEFINITION_ID = @er_stats_definition_id
		AND a.year IN (@begin_year, @end_year)
		AND a.month BETWEEN @begin_month AND @end_month
	ORDER BY year, month
END


