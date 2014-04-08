CREATE procedure [dbo].[sp_report_ERDivisionSF_CoreMeasures]
	(
		@coid VARCHAR(5),
		@year INT
	)
AS
BEGIN
	DECLARE @t TABLE
		(
			MONTH INT,
			score INT
		)

	DECLARE @month INT

	SELECT @month = 1

	WHILE @month <= 12
		BEGIN
			IF NOT EXISTS
				(
					SELECT 1
					FROM dbo.ER_CORE_MEASURE
					WHERE coid = @coid
						AND month = @month
						AND year = @year
				)  
				BEGIN
					INSERT INTO @t ( MONTH, score )
					VALUES  ( @month, 0 )          
				END;
			ELSE
				BEGIN
					INSERT INTO @t ( MONTH, score )
					SELECT month, score
					FROM dbo.ER_CORE_MEASURE WITH (NOLOCK)
					WHERE coid = @coid
						AND year = @year
						AND month = @month
				END;  
			
			SELECT @month = @month + 1;        
		END;    

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
				SELECT month, score
				FROM @t
				GROUP BY month, score
			) AS SourceTable
		PIVOT
			(
				SUM(score)
				FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
			) AS PivotTable;
END;

