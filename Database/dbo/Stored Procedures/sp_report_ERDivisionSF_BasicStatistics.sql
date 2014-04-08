

CREATE PROCEDURE [dbo].[sp_report_ERDivisionSF_BasicStatistics]
	(
		@year INT,
		@coid VARCHAR(5),
		@er_stat_ids VARCHAR(100),
		@combine_lwot_counts BIT,
		@include_targets BIT = 0,
		@maxMonth int
	)
AS
BEGIN
	IF @er_stat_ids = ''
		BEGIN;
			RETURN;
		END;

	DECLARE @results TABLE
		(
			coid VARCHAR(5),
			facility VARCHAR(50),
			MONTH int,
			YEAR int,
			er_daily_stats_definition_id INT,
			stat_definition VARCHAR(100),
			total DECIMAL(18, 4),
			sort_order INT,
			division_rollup_sort_order INT,
			division VARCHAR(50),
			is_calculated BIT,
			managing_company VARCHAR(50),
			numerator_stat_id INT,
			goal VARCHAR(100),
			rollup_is_average BIT DEFAULT 0,
			is_target BIT DEFAULT 0,
			ytd_run_rate_is_time bit default 0
		);
		  
	DECLARE @er_daily_stats_definition_id INT
	DECLARE @facility VARCHAR(50)
	DECLARE @division VARCHAR(50)
	DECLARE @managing_company VARCHAR(50)
	DECLARE @month int

	SELECT @month = 1;

	SELECT @facility = f.NAME,
		@managing_company = edm.NAME,
		@division = d.name
	FROM Facility f WITH (NOLOCK)
		JOIN dbo.EDM_MANAGING_COMPANY edm WITH (NOLOCK)
			ON f.EDM_MANAGING_COMPANY_ID = edm.EDM_MANAGING_COMPANY_ID  

		JOIN Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
	WHERE f.coid = @coid;
	
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT items FROM dbo.split(@er_stat_ids, ',')
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @er_daily_stats_definition_id;

	WHILE @@fetch_status = 0
		BEGIN
			WHILE @month <= @maxMonth
				begin			  
					IF EXISTS
						(
							SELECT 1
							FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
							WHERE coid = @coid
								AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								AND month = @month
								AND year = @year
						)            
						begin
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
									month,
									year,
									stat_definition,
									total,
									sort_order,
									division_rollup_sort_order,
									division,
									is_calculated,
									managing_company,
									numerator_stat_id,
									goal,
									rollup_is_average,
									ytd_run_rate_is_time
								)
							SELECT
								@coid,
								@facility,
								a.ER_DAILY_STATS_DEFINITION_ID,
								@month,
								@year,
								a.name,
								CASE
									WHEN a.ROLLUP_IS_AVERAGE = 1 THEN de.AVERAGE
									WHEN a.IS_CALCULATED = 1 THEN de.AVERAGE
									ELSE de.TOTAL 
								END,
								a.SORT_ORDER,
								a.DIVISION_ROLLUP_SORT_ORDER,
								@division,
								a.IS_CALCULATED,
								@managing_company,
								a.NUMERATOR_STAT_ID,
								a.goal,
								a.ROLLUP_IS_AVERAGE,
								a.ytd_run_rate_is_time
							FROM dbo.ER_DAILY_ENTRY de WITH (NOLOCK)
								JOIN dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
									ON de.ER_DAILY_STATS_DEFINITION_ID = a.ER_DAILY_STATS_DEFINITION_ID
							WHERE de.COID = @coid
								AND de.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								AND de.MONTH = @month
								AND de.YEAR = @year;
						END;
					ELSE
						BEGIN
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
									MONTH,
									YEAR,
									stat_definition,
									total,
									sort_order,
									division_rollup_sort_order,
									division,
									is_calculated,
									managing_company,
									numerator_stat_id,
									goal,
									rollup_is_average,
									ytd_run_rate_is_time
								) 
							SELECT 
								@coid, 
								@facility,
								c.ER_DAILY_STATS_DEFINITION_ID, 
								@month,
								@year,
								c.name AS stat_definition,
								0,
								c.sort_order,
								c.division_rollup_sort_order,
								@division,
								c.IS_CALCULATED,
								@managing_company,
								c.NUMERATOR_STAT_ID,
								c.goal,
								c.ROLLUP_IS_AVERAGE,
								c.ytd_run_rate_is_time
							FROM dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
							WHERE c.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
						END;                  

					IF @include_targets = 1
						BEGIN
							PRINT 'here'                      
							INSERT INTO @results
							(
								coid,
								facility,
								er_daily_stats_definition_id,
								month,
								year,
								stat_definition,
								total,
								sort_order,
								division_rollup_sort_order,
								division,
								is_calculated,
								managing_company,
								numerator_stat_id,
								goal,
								rollup_is_average,
								is_target,
								ytd_run_rate_is_time
							)
							SELECT
								@coid,
								@facility,
								a.ER_DAILY_STATS_DEFINITION_ID,
								@month,
								@year,
								de.NAME,
								de.target,
								a.SORT_ORDER,
								de.DIVISION_ROLLUP_SORT_ORDER,
								@division,
								a.IS_CALCULATED,
								@managing_company,
								a.NUMERATOR_STAT_ID,
								a.goal,
								a.ROLLUP_IS_AVERAGE,
								1,
								a.ytd_run_rate_is_time
							FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET de WITH (NOLOCK)
								JOIN dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
									ON de.ER_DAILY_STATS_DEFINITION_ID = a.ER_DAILY_STATS_DEFINITION_ID
							WHERE de.COID = @coid
								AND de.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								AND de.MONTH = @month
								AND de.YEAR = @year;
						END;

						SELECT @month = @month + 1; 
				END;

			SELECT @month = 1;

			FETCH NEXT FROM cur
			INTO @er_daily_stats_definition_id;
		END;
			
	CLOSE cur
	DEALLOCATE cur;

	IF @combine_lwot_counts = 1
		BEGIN      
			DECLARE @lwot_total DECIMAL(18, 4);
			
			SELECT @month = 1;
			
			WHILE @month < @maxMonth
				begin		
					SELECT @lwot_total = ISNULL(SUM(total), 0)
					FROM @results
					WHERE coid = @coid
						AND er_daily_stats_definition_id IN (8, 9)
							AND MONTH = @month
						
					INSERT INTO @results
						(
							coid,
							facility,
							er_daily_stats_definition_id,
							MONTH,
							YEAR,
							stat_definition,
							total,
							sort_order,
							division_rollup_sort_order,
							division,
							is_calculated,
							managing_company,
							numerator_stat_id,
							goal,
							rollup_is_average
						)
					SELECT
						@coid,
						@facility,
						c.ER_DAILY_STATS_DEFINITION_ID, 
						@month,
						@year,
						c.name AS stat_definition,
						@lwot_total,
						c.sort_order,
						c.division_rollup_sort_order,
						@division,
						c.IS_CALCULATED,
						@managing_company,
						c.NUMERATOR_STAT_ID,
						c.goal,
						c.ROLLUP_IS_AVERAGE
					FROM dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
					WHERE c.ER_DAILY_STATS_DEFINITION_ID = 41

					DECLARE @total_visits DECIMAL(18, 4);
					SELECT @total_visits = COUNT(1)
					FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
					WHERE coid = @coid
						AND YEAR_OF_DISCHARGE_DATE = @year
						AND MONTH_OF_DISCHARGE_DATE = @month;

					IF @total_visits <> 0
						BEGIN
							DECLARE @result DECIMAL(18, 4);
							
							SELECT @result = (@lwot_total / @total_visits);
							
							UPDATE @results
							SET total = @result
							WHERE coid = @coid
								AND er_daily_stats_definition_id = 17
								AND MONTH = @month;
						END; 
						
					SELECT @month = @month + 1;
				END;                     
						           
		END;
		        
	/*
	UPDATE @results
	SET total = 0
	WHERE is_calculated = 1;
	*/
	 
	UPDATE a
	SET a.goal = b.target
	FROM @results a
		JOIN dbo.ER_DAILY_STATS_DEFINITION_TARGET b
			ON a.coid = b.COID
				AND a.ER_DAILY_STATS_DEFINITION_ID = b.ER_DAILY_STATS_DEFINITION_ID
				AND a.MONTH = b.MONTH
				AND a.YEAR = b.year;

	UPDATE a
	SET a.goal = b.compare_goal
	FROM @results a 
		JOIN dbo.ER_DAILY_STATS_DEFINITION b
			ON a.ER_DAILY_STATS_DEFINITION_ID = b.ER_DAILY_STATS_DEFINITION_ID
	WHERE a.ER_DAILY_STATS_DEFINITION_ID IN (16, 17);

	SELECT 
		coid,
		facility,
		MONTH,
		YEAR,
		er_daily_stats_definition_id,
		stat_definition,
		total,
		sort_order,
		division_rollup_sort_order,
		division,
		is_calculated,
		managing_company,
		numerator_stat_id,
		ISNULL(goal, '0') AS goal,
		rollup_is_average,
		is_target,
		ytd_run_rate_is_time
	FROM @results
	ORDER BY facility, MONTH, division_rollup_sort_order;
END

