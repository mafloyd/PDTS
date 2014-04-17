
CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_BasicStatistics]
	(
		@year INT,
		@month INT,
		@division_id INT,
		@er_stat_ids VARCHAR(100),
		@combine_lwot_counts BIT = 0,
		@includeTargetValues BIT = 0,
		@edm_managing_company_id INT = 0
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
			er_daily_stats_definition_id INT,
			stat_definition VARCHAR(100),
			total DECIMAL(18, 2),
			sort_order INT,
			division_rollup_sort_order INT,
			division VARCHAR(50),
			is_calculated BIT,
			managing_company VARCHAR(50),
			numerator_stat_id INT,
			goal VARCHAR(100),
			is_target BIT DEFAULT 0,
			rollup_is_average BIT DEFAULT 0,
			TARGET DECIMAL(18, 2) DEFAULT 0,
			target_is_percentage BIT DEFAULT 0,
			compare_goal DECIMAL(18, 2) DEFAULT 0,
			target_column VARCHAR(50),
			target_column_background VARCHAR(50) DEFAULT 'White',
			edm_managing_company_id INT,
			division_id int
		);
		  
	DECLARE @er_daily_stats_definition_id INT
	DECLARE @total INT;  
	DECLARE @coid VARCHAR(5)
	DECLARE @facility VARCHAR(50)
	DECLARE @division VARCHAR(50)
	DECLARE @division_id_cur int
	DECLARE @managing_company VARCHAR(50)
	DECLARE @managing_company_id int
  
	DECLARE fac_cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT DISTINCT f.coid, f.NAME, d.NAME, e.NAME, ISNULL(f.EDM_MANAGING_COMPANY_ID, 0), f.DIVISION_ID
	FROM dbo.Facility f WITH (NOLOCK)
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
				AND f.SHOW_IN_DETAIL_REPORTS = 1
				
		LEFT JOIN dbo.EDM_MANAGING_COMPANY e WITH (NOLOCK)
			ON f.EDM_MANAGING_COMPANY_ID = e.EDM_MANAGING_COMPANY_ID
	ORDER BY f.name;
	
	OPEN fac_cur
	
	FETCH NEXT FROM fac_cur
	INTO @coid, @facility, @division, @managing_company, @managing_company_id, @division_id_cur
	
	WHILE @@fetch_status = 0
		BEGIN  
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT items FROM dbo.split(@er_stat_ids, ',')
	
			OPEN cur
	
			FETCH NEXT FROM cur
			INTO @er_daily_stats_definition_id;

			WHILE @@fetch_status = 0
				BEGIN
					IF EXISTS
						(
							SELECT 1
							FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
							WHERE coid = @coid
								AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								AND year = @year
								AND month = @month
						)
						BEGIN 
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
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
									compare_goal,
									edm_managing_company_id,
									division_id
								)                      
							SELECT 
								@coid, 
								@facility,
								c.ER_DAILY_STATS_DEFINITION_ID, 
								c.name AS stat_definition,
								CASE 
									WHEN c.ROLLUP_IS_AVERAGE = 1 THEN a.AVERAGE
									ELSE a.TOTAL END,
								c.sort_order,
								c.division_rollup_sort_order,
								@division,
								c.IS_CALCULATED,
								@managing_company,
								c.NUMERATOR_STAT_ID,
								c.goal,
								c.ROLLUP_IS_AVERAGE,
								c.COMPARE_GOAL,
								@managing_company_id,
								@division_id_cur
							FROM dbo.ER_DAILY_ENTRY a WITH (NOLOCK)
								JOIN dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
									ON a.ER_DAILY_STATS_DEFINITION_ID = c.ER_DAILY_STATS_DEFINITION_ID
							WHERE a.coid = @coid
								AND a.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								and a.year = @year
								AND a.month = @month
						END;
					ELSE
						BEGIN
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
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
									compare_goal,
									edm_managing_company_id,
									division_id
								) 
							SELECT 
								@coid, 
								@facility,
								c.ER_DAILY_STATS_DEFINITION_ID, 
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
								c.COMPARE_GOAL,
								@managing_company_id,
								@division_id_cur
							FROM dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
							WHERE c.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
						END;                          

				
					INSERT INTO @results
						(
							coid,
							facility,
							er_daily_stats_definition_id,
							stat_definition,
							total,
							sort_order,
							division_rollup_sort_order,
							division,
							is_calculated,
							managing_company,
							numerator_stat_id,
							goal,
							is_target,
							TARGET,
							target_is_percentage,
							edm_managing_company_id,
							division_id
						)       
					SELECT 
						@coid,
						@facility,
						target.ER_DAILY_STATS_DEFINITION_ID,
						target.NAME,
						target.TARGET,
						0,
						target.DIVISION_ROLLUP_SORT_ORDER,
						@division,
						0,
						@managing_company,
						0,
						target.target,
						1,
						TARGET,
						target.TARGET_IS_PERCENTAGE,
						@managing_company_id,
						@division_id_cur
					FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET target WITH (NOLOCK)
					WHERE target.coid = @coid
						AND target.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
						AND target.year = @year
						AND target.MONTH = @month                  
					   
			FETCH NEXT FROM cur
			INTO @er_daily_stats_definition_id;
		END;
			
		CLOSE cur
		DEALLOCATE cur;

		IF @combine_lwot_counts = 1
			BEGIN
				DECLARE @lwot_total DECIMAL(18, 2);
					
				SELECT @lwot_total = SUM(total)
				FROM @results
				WHERE coid = @coid
					AND er_daily_stats_definition_id IN (8, 9)
						
				INSERT INTO @results
					(
						coid,
						facility,
						er_daily_stats_definition_id,
						stat_definition,
						total,
						sort_order,
						division_rollup_sort_order,
						division,
						is_calculated,
						managing_company,
						numerator_stat_id,
						goal,
						compare_goal,
						edm_managing_company_id,
						division_id
					)
				SELECT
					@coid,
					@facility,
					c.ER_DAILY_STATS_DEFINITION_ID, 
					c.name AS stat_definition,
					@lwot_total,
					c.sort_order,
					c.division_rollup_sort_order,
					@division,
					c.IS_CALCULATED,
					@managing_company,
					c.NUMERATOR_STAT_ID,
					c.goal,
					c.COMPARE_GOAL,
					@managing_company_id,
					@division_id_cur
				FROM dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
				WHERE c.ER_DAILY_STATS_DEFINITION_ID = 41

				DECLARE @total_visits DECIMAL(18, 2);
				SELECT @total_visits = COUNT(1)
				FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
				WHERE coid = @coid
					AND YEAR_OF_DISCHARGE_DATE = @year
					AND MONTH_OF_DISCHARGE_DATE = @month;

				IF @total_visits <> 0
					BEGIN
						DECLARE @result DECIMAL(18, 2);
							
						SELECT @result = (@lwot_total / @total_visits);
							
						UPDATE @results
						SET total = @result
						WHERE coid = @coid
							AND er_daily_stats_definition_id = 17;                      
					END;   
			END;
		              
		FETCH NEXT FROM fac_cur
		INTO @coid, @facility, @division, @managing_company, @managing_company_id, @division_id_cur
	END;

	CLOSE fac_cur;
	DEALLOCATE fac_cur;

	UPDATE a
	SET a.target = 
		(
			SELECT target 
			FROM @results
			WHERE coid = a.coid 
				AND er_daily_stats_definition_id = a.er_daily_stats_definition_id
				AND is_target = 1
		)
	FROM @results a
	WHERE is_target = 0

	IF @includetargetvalues = 0
		BEGIN
			DELETE
			FROM @results
			WHERE is_target = 1;      

			UPDATE @results
			SET target = compare_goal;

			UPDATE a
			SET a.target_column = a.goal
			FROM @results a
			WHERE NOT EXISTS
				(
					SELECT 1
					FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET
					WHERE coid = a.coid
						AND ER_DAILY_STATS_DEFINITION_ID = a.er_daily_stats_definition_id
				);
		END;
		      
	UPDATE a
	SET a.target_column = 'By hospital'
	FROM @results a
	WHERE EXISTS 
		(
			SELECT 1
			FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET
			WHERE coid = a.coid
				AND ER_DAILY_STATS_DEFINITION_ID = a.er_daily_stats_definition_id
		)
		AND is_target = 1;

	UPDATE @results
	SET target_column_background = 'Black'
	WHERE target_column IS NULL;

	IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id      
		END;      

	IF @edm_managing_company_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE ISNULL(edm_managing_company_id, 0) <> @edm_managing_company_id      
		END;
		      
	SELECT *
	FROM @results
	ORDER BY facility, division_rollup_sort_order;
END

