

CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_EDRankingByTier]
	(
		@year INT,
		@month INT,
		@er_stat_ids VARCHAR(100),
		@combine_lwot_counts BIT = 0
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
			is_calculated BIT,
			numerator_stat_id INT,
			goal VARCHAR(100),
			ed_tier_ranking_id INT,
			ed_tier_ranking VARCHAR(50),
			average DECIMAL(18, 2),
			rollup_is_average BIT DEFAULT 0
		);
		  
	DECLARE @er_daily_stats_definition_id INT
	DECLARE @total INT;  
	DECLARE @coid VARCHAR(5)
	DECLARE @facility VARCHAR(50)
	DECLARE @ed_tier_ranking_id INT
	DECLARE @ed_tier_ranking VARCHAR(50)  
  
	DECLARE fac_cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT f.coid, f.NAME, f.ED_TIER_RANKING_ID, mtr.NAME
	FROM dbo.Facility f WITH (NOLOCK)
		JOIN dbo.MASTER_ED_TIER_RANKING mtr WITH (NOLOCK)
			ON f.ED_TIER_RANKING_ID = mtr.ED_TIER_RANKING_ID
	WHERE f.ED_TIER_RANKING_ID IS NOT NULL
	ORDER BY f.ED_TIER_RANKING_ID, f.name  
				
	OPEN fac_cur
	
	FETCH NEXT FROM fac_cur
	INTO @coid, @facility, @ed_tier_ranking_id, @ed_tier_ranking
	
	WHILE @@fetch_status = 0
		BEGIN  
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT items FROM dbo.split(@er_stat_ids, ',')
	
			OPEN cur
	
			FETCH NEXT FROM cur
			INTO @er_daily_stats_definition_id;

			WHILE @@fetch_status = 0
				BEGIN
					IF @er_daily_stats_definition_id = 15
						BEGIN
							SELECT @total = COUNT(1)
							FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
							WHERE coid = @coid
								AND YEAR_OF_DISCHARGE_DATE = @year
								AND MONTH_OF_DISCHARGE_DATE = @month;
						
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
									stat_definition,
									total,
									sort_order,
									division_rollup_sort_order,
									is_calculated,
									numerator_stat_id,
									goal,
									ed_tier_ranking_id,
									ed_tier_ranking,
									rollup_is_average
								)
							SELECT
								@coid,
								@facility,
								a.ER_DAILY_STATS_DEFINITION_ID,
								a.name,
								@total,
								a.SORT_ORDER,
								a.DIVISION_ROLLUP_SORT_ORDER,
								a.IS_CALCULATED,
								a.NUMERATOR_STAT_ID,
								a.goal,
								@ed_tier_ranking_id,
								@ed_tier_ranking,
								0
							FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
							WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id;
						END;
					else IF @er_daily_stats_definition_id = 10
						BEGIN
							SELECT @total = 0;
							SELECT @total = COUNT(1)
							FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
							WHERE coid = @coid
								AND YEAR_OF_DISCHARGE_DATE = @year
								AND MONTH_OF_DISCHARGE_DATE = @month
								AND PAT_TYPE_POS1 = 'I'; 
								
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
									stat_definition,
									total,
									sort_order,
									division_rollup_sort_order,
									is_calculated,
									numerator_stat_id,
									goal,
									ed_tier_ranking_id,
									ed_tier_ranking
								)
							SELECT
								@coid,
								@facility,
								a.ER_DAILY_STATS_DEFINITION_ID,
								a.name,
								@total,
								a.SORT_ORDER,
								a.DIVISION_ROLLUP_SORT_ORDER,
								a.IS_CALCULATED,
								a.NUMERATOR_STAT_ID,
								a.goal,
								@ed_tier_ranking_id,
								@ed_tier_ranking
							FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
							WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id;                     
						END;                      
					else IF @er_daily_stats_definition_id = 11
						BEGIN
							SELECT @total = 0;
							SELECT @total = COUNT(1)
							FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
							WHERE coid = @coid
								AND YEAR_OF_DISCHARGE_DATE = @year
								AND MONTH_OF_DISCHARGE_DATE = @month
								AND OBSERVATION = 1;
								
							INSERT INTO @results
								(
									coid,
									facility,
									er_daily_stats_definition_id,
									stat_definition,
									total,
									sort_order,
									division_rollup_sort_order,
									is_calculated,
									numerator_stat_id,
									goal,
									ed_tier_ranking_id,
									ed_tier_ranking
								)
							SELECT
								@coid,
								@facility,
								a.ER_DAILY_STATS_DEFINITION_ID,
								a.name,
								@total,
								a.SORT_ORDER,
								a.DIVISION_ROLLUP_SORT_ORDER,
								a.IS_CALCULATED,
								a.NUMERATOR_STAT_ID,
								a.goal,
								@ed_tier_ranking_id,
								@ed_tier_ranking
							FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
							WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id;                     
						END;
					ELSE
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
											is_calculated,
											numerator_stat_id,
											goal,
											ed_tier_ranking_id,
											ed_tier_ranking,
											average,
											rollup_is_average
										)                      
									SELECT 
										@coid, 
										@facility,
										c.ER_DAILY_STATS_DEFINITION_ID, 
										c.name AS stat_definition,
										a.TOTAL,
										c.sort_order,
										c.division_rollup_sort_order,
										c.IS_CALCULATED,
										c.NUMERATOR_STAT_ID,
										c.goal,
										@ed_tier_ranking_id,
										@ed_tier_ranking,
										a.AVERAGE,
										c.ROLLUP_IS_AVERAGE
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
											is_calculated,
											numerator_stat_id,
											goal,
											ed_tier_ranking_id,
											ed_tier_ranking,
											average,
											rollup_is_average
										) 
									SELECT 
										@coid, 
										@facility,
										c.ER_DAILY_STATS_DEFINITION_ID, 
										c.name AS stat_definition,
										0,
										c.sort_order,
										c.division_rollup_sort_order,
										c.IS_CALCULATED,
										c.NUMERATOR_STAT_ID,
										c.goal,
										@ed_tier_ranking_id,
										@ed_tier_ranking,
										0,
										c.ROLLUP_IS_AVERAGE
									FROM dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
									WHERE c.ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
								END;                          
						END;                  

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
							is_calculated,
							numerator_stat_id,
							goal,
							ed_tier_ranking_id,
							ed_tier_ranking,
							rollup_is_average
						)
					SELECT
						@coid,
						@facility,
						c.ER_DAILY_STATS_DEFINITION_ID, 
						c.name AS stat_definition,
						@lwot_total,
						c.sort_order,
						c.division_rollup_sort_order,
						c.IS_CALCULATED,
						c.NUMERATOR_STAT_ID,
						c.goal,
						@ed_tier_ranking_id,
						@ed_tier_ranking,
						c.ROLLUP_IS_AVERAGE
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
		INTO @coid, @facility, @ed_tier_ranking_id, @ed_tier_ranking
	END;

	CLOSE fac_cur;
	DEALLOCATE fac_cur;

	DELETE
	FROM @results
	WHERE er_daily_stats_definition_id IN (8, 9);
	  
	SELECT *
	FROM @results
	ORDER BY ed_tier_ranking_id, facility, division_rollup_sort_order
END

