CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_CoreMeasures]
	(
		@division_id INT,
		@month INT,
		@year INT,
		@edm_managing_company_id INT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @results TABLE
	(
		coid VARCHAR(5),
		NAME VARCHAR(50),
		stat_definition VARCHAR(50),
		score INT,
		edm_managing_company_id INT,
		division_id INT
	)  

	INSERT INTO @results ( coid, NAME, stat_definition, score, edm_managing_company_id, division_id )
    SELECT DISTINCT f.coid, f.name, 'ED Core Measure Compliance' AS stat_definition, b.score, f.EDM_MANAGING_COMPANY_ID, f.DIVISION_ID
	FROM dbo.Facility f WITH (NOLOCK)
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
				AND f.SHOW_IN_DETAIL_REPORTS = 1

		LEFT JOIN dbo.ER_CORE_MEASURE b WITH (NOLOCK)
			ON f.COID = b.COID
				AND b.month = @month
				AND b.year = @year
	
	IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id;      
		END;
		      
	IF @edm_managing_company_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE ISNULL(edm_managing_company_id, 0) <> @edm_managing_company_id;      
		END;
		      
	SELECT *
	FROM @results
	ORDER BY name;
END

