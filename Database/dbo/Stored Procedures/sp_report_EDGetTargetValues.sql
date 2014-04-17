CREATE PROCEDURE [dbo].[sp_report_EDGetTargetValues]
	(
		@er_daily_stats_definition_id INT,
		@YEAR int,
		@MONTH int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT er_daily_stats_definition_target_id,
		coid,
		TARGET
	FROM ER_DAILY_STATS_DEFINITION_TARGET WITH (NOLOCK)
	WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
		AND year = @year
		AND month = @month;       
END

