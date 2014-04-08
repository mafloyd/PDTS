CREATE PROCEDURE [dbo].[sp_report_ED_PatientAnalysis_ObsVisits2]
	(
		@coid VARCHAR(5),
		@year INT,
		@month int
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @t TABLE
		(
			cm INT,
			cm_py INT,
			ytd INT,
			ytd_py INT,
			stat VARCHAR(50)
		);

	INSERT INTO @t (cm, cm_py, ytd, ytd_py, stat)
	VALUES (0, 0, 0, 0, 'ED Visits to Obs');

	UPDATE @t
	SET cm = 
		(
			SELECT COUNT(OBSERVATION) 
			FROM dbo.ER_MONTHLY_DATA
			WHERE coid = @coid
				AND MONTH_OF_DISCHARGE_DATE = @month
				AND YEAR_OF_DISCHARGE_DATE = @year
				AND OBSERVATION = 1
		)

	UPDATE @t
	SET cm_py = 
		(
			SELECT COUNT(OBSERVATION) 
			FROM dbo.ER_MONTHLY_DATA
			WHERE coid = @coid
				AND MONTH_OF_DISCHARGE_DATE = @month
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND OBSERVATION = 1
		)

	UPDATE @t
	SET ytd = 
		(
			SELECT COUNT(OBSERVATION) 
			FROM dbo.ER_MONTHLY_DATA
			WHERE coid = @coid
				AND MONTH_OF_DISCHARGE_DATE <= @month
				AND YEAR_OF_DISCHARGE_DATE = @year
				AND OBSERVATION = 1
		)

		UPDATE @t
	SET ytd_py = 
		(
			SELECT COUNT(OBSERVATION) 
			FROM dbo.ER_MONTHLY_DATA
			WHERE coid = @coid
				AND MONTH_OF_DISCHARGE_DATE <= @month
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND OBSERVATION = 1
		)

	SELECT *
	FROM @t;
END

