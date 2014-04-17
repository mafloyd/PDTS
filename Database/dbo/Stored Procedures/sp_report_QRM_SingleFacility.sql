CREATE PROCEDURE [dbo].[sp_report_QRM_SingleFacility]
	(
		@coid VARCHAR(5),
		@YEAR INT,
		@qrm_measure_type_group_id int
	)
AS
BEGIN	  
	DECLARE @t TABLE
		(
			qrm_measure_type_id INT,
			month_1 INT,
			month_2 INT,
			month_3 INT,
			month_4 INT,
			month_5 INT,
			month_6 INT,
			month_7 INT,
			MONTH_8 INT,
			month_9 INT,
			month_10 INT,
			month_11 INT,
			month_12 int
		);
		  
	declare @measures table
		(
			facility VARCHAR(50),
			qrm_measure_type_id INT,
			measure_name VARCHAR(250),
			month_1 INT,
			month_2 INT,
			month_3 INT,
			month_4 INT,
			month_5 INT,
			month_6 INT,
			month_7 INT,
			month_8 INT,
			month_9 INT,
			month_10 INT,
			month_11 INT,
			month_12 INT,
			summarized_stat_definition_id INT,
			Q1 DECIMAL(18, 2),
			Q2 DECIMAL(18, 2),
			Q3 DECIMAL(18, 2),
			Q4 DECIMAL(18, 2),
			YTD DECIMAL(18, 2)
		);

	DECLARE @qrm_measure_type_id INT;
	DECLARE @facility VARCHAR(50);
	DECLARE @measure_name VARCHAR(250);
	DECLARE @summarized_stat_definition_id INT;
	DECLARE @month INT;  
	DECLARE @sql VARCHAR(4000);

	SET NOCOUNT ON;
		
	SELECT @facility = name
	FROM Facility WITH (NOLOCK)
	WHERE coid = @coid;

    DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT qrm_measure_type_id, name, summarized_stat_definition_id
	FROM dbo.QRM_MEASURE_TYPE WITH (NOLOCK)
	WHERE report_sort_order IS NOT NULL
		AND qrm_measure_type_group_id = @qrm_measure_type_group_id  
	ORDER BY REPORT_SORT_ORDER

	OPEN cur

	FETCH NEXT FROM cur
	INTO @qrm_measure_type_id, @measure_name, @summarized_stat_definition_id

	WHILE @@fetch_status = 0
		BEGIN
			INSERT INTO @measures (facility, qrm_measure_type_id, measure_name, summarized_stat_definition_id)
			VALUES (@facility, @qrm_measure_type_id, @measure_name, @summarized_stat_definition_id);              
			          
			IF ISNULL(@summarized_stat_definition_id, 0) = 0
				BEGIN              
					INSERT INTO @t (qrm_measure_type_id, month_1, month_2, month_3, month_4, month_5, month_6, month_7, month_8, month_9, month_10, month_11, month_12)
					SELECT @qrm_measure_type_id, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
					FROM 
						(
							SELECT reporting_period_month, value AS xvalue
							FROM qrm_measure WITH (NOLOCK)
							WHERE QRM_MEASURE_TYPE_ID = @qrm_measure_type_id
								AND REPORTING_PERIOD_YEAR = @YEAR
								AND coid = @coid
						) AS SourceTable
					PIVOT
						(
							SUM(xvalue)
							FOR reporting_period_month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
						) AS PivotTable;

					UPDATE b
					SET b.month_1 = a.month_1,
						b.month_2 = a.month_2,
						b.month_3 = a.month_3,
						b.month_4 = a.month_4,
						b.month_5 = a.month_5,
						b.month_6 = a.month_6,
						b.month_7 = a.month_7,
						b.month_8 = a.month_8,
						b.month_9 = a.month_9,
						b.month_10 = a.month_10,
						b.month_11 = a.month_11,
						b.month_12 = a.month_12
					FROM @t a
						JOIN @measures b
							ON a.qrm_measure_type_id = b.qrm_measure_type_id;

					DELETE FROM @t;
				END;
			              
			FETCH NEXT FROM cur
			INTO @qrm_measure_type_id, @measure_name, @summarized_stat_definition_id
		END;
		
	CLOSE cur;
	DEALLOCATE cur;    

	UPDATE a
	SET a.month_1 = b.JAN,
		a.month_2 = b.FEB,
		a.month_3 = b.MAR,
		a.month_4 = b.APR,
		a.month_5 = b.MAY,
		a.month_6 = b.JUN,
		a.month_7 = b.JUL,
		a.month_8 = b.AUG,
		a.month_9 = b.SEP,
		a.month_10 = b.OCT,
		a.month_11 = b.NOV,
		a.month_12 = b.DEC,
		a.Q1 = b.Q1,
		a.Q2 = b.Q2,
		a.Q3 = b.Q3,
		a.Q4 = b.Q4,
		a.YTD = b.YTD
	FROM @measures a 
		JOIN dbo.SUMMARIZED_STATS b 
			ON a.summarized_stat_definition_id = b.SUMMARIZED_STAT_DEFINITION_ID
	WHERE b.coid = @coid
		AND b.year = @year
	SELECT *
	FROM @measures;
END

