CREATE procedure [dbo].[sp_report_ED_PatientAnalysisMTD_YTD]
	(
		@coid VARCHAR(5),
		@er_daily_stats_definition_id INT,
		@month INT,
		@year int
	)
AS
begin
	SET NOCOUNT ON;

	SELECT @coid = '05450';
	SELECT @er_daily_stats_definition_id = 11
	SELECT @month = 3
	SELECT @year = 2013

	DECLARE @results TABLE	
		(
			stat VARCHAR(50),
			cm DECIMAL(18, 2),
			cm_py DECIMAL(18, 2),
			ytd DECIMAL(18, 2),
			ytd_py DECIMAL(18, 2)
		);

	INSERT INTO @results (stat)
	SELECT name
	FROM dbo.ER_DAILY_STATS_DEFINITION
	WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id;

	UPDATE @results
	SET cm =
		(
			SELECT total
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
				AND month = @month
				AND year = @year
		),
		cm_py =
		(
			SELECT total
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
				AND month = @month
				AND year = (@year - 1)
		),
		ytd =
		(
			SELECT SUM(total)
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
				AND month <= @month
				AND year = @year
		),
		ytd_py =
		(
			SELECT SUM(total)
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
				AND month <= @month
				AND year = (@year - 1)
		)

	SELECT
		stat,
		ISNULL(cm, 0) AS cm,
		ISNULL(cm_py, 0) AS cm_py,
		ISNULL(ytd, 0) AS ytd,
		ISNULL(ytd_py, 0) AS ytd_py
	FROM @results;
END;

