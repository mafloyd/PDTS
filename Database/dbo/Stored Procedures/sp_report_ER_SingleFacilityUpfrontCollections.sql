CREATE PROCEDURE [dbo].[sp_report_ER_SingleFacilityUpfrontCollections]
	(
		@coid VARCHAR(5),
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF object_id('tempdb..#sfuc') IS NOT null
		BEGIN
			DROP TABLE #sfuc;      
		END;
		    
	DECLARE @sfuc TABLE
		(  
			stat VARCHAR(50),
			coid varchar(5),
			MONTH int,
			percentage decimal(5, 2)
		);

	CREATE TABLE #sfuc
		(
			stat VARCHAR(50),
			coid varchar(5),
			MONTH int,
			percentage decimal(5, 2)
		)

	INSERT INTO @sfuc
	SELECT
		'Upfront Collections', 
		coid, 
		month, 
		percentage
	FROM dbo.ER_UPFRONT_COLLECTION
	WHERE coid = @coid
		AND year = @year
	ORDER BY coid, month

	DECLARE @month INT;
	SELECT @month = 1;
	  
	WHILE @month < 13
		BEGIN
			IF NOT EXISTS 
				(
					SELECT 1
					FROM @sfuc
					WHERE month = @month
				)
				BEGIN				      
					INSERT INTO @sfuc ( stat, coid, MONTH, percentage )
					VALUES ('Upfront Collections', @coid, @month, 0)
				END;

			SELECT @month = @month + 1;
		END;

	INSERT INTO #sfuc
	        ( stat, coid, MONTH, percentage )
	SELECT stat, coid, month, percentage
	FROM @sfuc
	ORDER BY month;

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
		[12] AS dec
	FROM
		(
			SELECT MONTH, SUM(percentage) AS percentage
			FROM @sfuc
			GROUP BY month
		) AS SourceTable
	PIVOT
		(
			SUM(percentage)
			FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
		) AS PivotTable
END;

