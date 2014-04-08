CREATE PROCEDURE [dbo].[sp_report_ED_PatientAnalysis_ObsVisits]
	(
		@coid VARCHAR(5),
		@month INT,
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @results table
		(
			current_month INT,
			current_month_py INT,
			ytd INT,
			ytd_py int
		)

	INSERT INTO @results 
	VALUES (0, 0, 0, 0)

	UPDATE @results
	SET current_month = 
		(
			SELECT ISNULL(SUM(a.OBS_VISITS), 0)
			FROM dbo.DailyObsVisits a WITH (NOLOCK)
			WHERE coid = @coid
				AND monthno = @month
				AND year = @year
		);

	UPDATE @results
	SET current_month_py = 
		(
			SELECT ISNULL(SUM(a.OBS_VISITS), 0)
			FROM dbo.DailyObsVisits a WITH (NOLOCK)
			WHERE coid = @coid
				AND monthno = @month
				AND year = (@year - 1)
		);

	UPDATE @results
	SET ytd = 
		(
			SELECT ISNULL(SUM(a.OBS_VISITS), 0)
			FROM dbo.DailyObsVisits a WITH (NOLOCK)
			WHERE coid = @coid
				AND monthno <= @month
				AND year = @year
		);

	UPDATE @results
	SET ytd_py = 
		(
			SELECT ISNULL(SUM(a.OBS_VISITS), 0)
			FROM dbo.DailyObsVisits a WITH (NOLOCK)
			WHERE coid = @coid
				AND monthno <= @month
				AND year = (@year - 1)
		);

	SELECT *
	FROM @results;
END

