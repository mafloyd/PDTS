
CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_EDSatisfaction]
	(
		@division_id INT,
		@YEAR int,
		@MONTH INT,
		@question_id VARCHAR(50),
		@include_targets BIT = 1,
		@edm_managing_company_id INT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @coid varchar(5);
	DECLARE @facility VARCHAR(50);
	DECLARE @division VARCHAR(50);
	DECLARE @managing_company VARCHAR(50);
	DECLARE @managing_company_id INT;
	DECLARE @max_quarter INT;
	DECLARE @max_year INT;
	DECLARE @top_box_answers VARCHAR(50);
	DECLARE @sql VARCHAR(4000)

	SELECT @top_box_answers = top_box_answers
	FROM dbo.SURVEY_QUESTION
	WHERE data_col = @question_id;

	IF object_id('tempdb..#divsat') IS NOT NULL
		BEGIN
			DROP TABLE #divsat;      
		END;      
	  
	CREATE TABLE #divsat
		(
			coid varchar(5),
			facility varchar(50),
			er_daily_stats_definition_id INT,
			stat_definition varchar(50),
			total int DEFAULT 0.00,
			division_rollup_sort_order int,
			division VARCHAR(50),
			is_calculated BIT,
			numerator DECIMAL(18, 2),
			denominator DECIMAL(18, 2),
			results DECIMAL(18, 2) DEFAULT 0.00,
			is_target BIT DEFAULT 0,
			TARGET DECIMAL(18, 2),
			edm_managing_company_id int
		);

    DECLARE @results TABLE
		(
			coid varchar(5),
			facility varchar(50),
			er_daily_stats_definition_id INT,
			stat_definition varchar(50),
			total int DEFAULT 0.00,
			division_rollup_sort_order int,
			division VARCHAR(50),
			is_calculated BIT,
			numerator DECIMAL(18, 2) DEFAULT 0,
			denominator DECIMAL(18, 2) DEFAULT 0,
			results DECIMAL(18, 2) DEFAULT 0.00,
			is_target BIT DEFAULT 0,
			TARGET DECIMAL(18, 2),
			edm_managing_company_id int
		);

	IF @division_id = 1 
		BEGIN
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT DISTINCT f.coid, f.name, d.name, e.name, ISNULL(f.EDM_MANAGING_COMPANY_ID, 0)
			FROM dbo.Facility f WITH (NOLOCK)
				JOIN Division d WITH (NOLOCK)
					ON f.DIVISION_ID = d.DIVISION_ID

				LEFT JOIN dbo.EDM_MANAGING_COMPANY e WITH (NOLOCK)
					ON f.EDM_MANAGING_COMPANY_ID = e.EDM_MANAGING_COMPANY_ID
			WHERE f.SHOW_IN_DETAIL_REPORTS = 1
			ORDER BY f.name;      
		END;
	ELSE
		BEGIN
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT DISTINCT f.coid, f.name, d.name, e.name, ISNULL(f.EDM_MANAGING_COMPANY_ID, 0)
			FROM dbo.Facility f WITH (NOLOCK)
				JOIN dbo.Division d WITH (NOLOCK)
					ON f.DIVISION_ID = d.DIVISION_ID
						AND d.DIVISION_ID = @division_id
					AND f.SHOW_IN_DETAIL_REPORTS = 1

				LEFT JOIN dbo.EDM_MANAGING_COMPANY e WITH (NOLOCK)
					ON f.EDM_MANAGING_COMPANY_ID = e.EDM_MANAGING_COMPANY_ID
			ORDER BY f.name;
		END;

	OPEN cur;

	FETCH NEXT FROM cur 
	INTO @coid, @facility, @division, @managing_company, @managing_company_id

	WHILE @@fetch_status = 0
		BEGIN      
			DECLARE @total int;

			INSERT INTO #divsat
				(
					coid,
					facility,
					er_daily_stats_definition_id,
					stat_definition,
					total,
					division_rollup_sort_order,
					division,
					is_calculated,
					edm_managing_company_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				@total,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company_id
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = 31; 

			SELECT @max_quarter = 0;

			SELECT @max_year = MAX(a.YEAR)
			FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
				JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
					ON a.QUESTION_ID = b.QUESTION_ID
						AND b.data_col = @question_id;
			  
			IF @max_year < @YEAR
				BEGIN
					SELECT @max_year = @year;              
				END;              

			SELECT @max_quarter = MAX(a.quarter)
			FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
				JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
					ON a.QUESTION_ID = b.QUESTION_ID
						AND b.data_col = @question_id;

			IF @max_quarter > 0
				BEGIN				
					UPDATE a
					SET results =
						(
							SELECT b.top_box_score
							FROM er_top_box_score b WITH (NOLOCK)
								JOIN dbo.SURVEY_QUESTION c WITH (NOLOCK)
									ON b.QUESTION_ID = c.QUESTION_ID
										AND c.data_col = @question_id
							WHERE b.coid = a.coid
								AND b.QUARTER = @max_quarter
								AND b.year = @year
						)	
					FROM #divsat a
					WHERE a.coid = @coid              
					--UPDATE #divsat
					--SET denominator = 
					--	(
					--		SELECT COUNT(1) 
					--		FROM SURVEY_CYCLE a WITH (NOLOCK)
					--			JOIN dbo.SurveyAnswer b WITH (NOLOCK)
					--				ON a.CYCLE_ID = b.CycleID
					--		WHERE a.coid = @coid
					--			AND b.year = @max_year
					--			AND b.quarter = @max_quarter
					--	)
					--WHERE coid = @coid;

					--SELECT @sql = 'UPDATE #divsat ';
					--SELECT @sql = @sql + 'SET numerator = ';
					--SELECT @sql = @sql + '( ';
					--SELECT @sql = @sql + 'SELECT COUNT(1) ';
					--SELECT @sql = @sql + 'FROM SURVEY_CYCLE a WITH (NOLOCK) ';
					--SELECT @sql = @sql + 'JOIN SurveyAnswer b WITH (NOLOCK) ';
					--SELECT @sql = @sql + 'ON a.CYCLE_ID = b.CycleID ';
					--SELECT @sql = @sql + 'WHERE a.coid =' + @coid + ' ';
					--SELECT @sql = @sql + 'AND b.YEAR = ' + CAST(@max_year AS VARCHAR(4)) + ' ';
					--SELECT @sql = @sql + 'AND b.quarter = ' + CAST(@max_quarter AS VARCHAR(1)) + ' ';
					--SELECT @sql = @sql + 'AND LTRIM(RTRIM(' + @question_id + ')) IN (' + @top_box_answers + ')';
					--SELECT @sql = @sql + ') ';
					--SELECT @sql = @sql + 'WHERE coid = ''' + @coid + ''' ';

					--EXEC(@sql);
				END;             

			IF @include_targets = 1
				BEGIN
					INSERT INTO #divsat
						(
							coid,
							facility,
							stat_definition,
							total,
							division_rollup_sort_order,
							division,
							results,
							is_target,
							is_calculated,
							edm_managing_company_id
						)
					SELECT 
						@coid,
						@facility,
						REPLACE(a.NAME,'@year', @max_year),
						@total,
						a.DIVISION_ROLLUP_SORT_ORDER,
						@division,
						a.target,
						1,
						1,
						@managing_company_id
					FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET a WITH (NOLOCK)
					WHERE coid = @coid
						AND month = @month
						AND year = @max_year
						AND ER_DAILY_STATS_DEFINITION_ID = 31
				END;

			FETCH NEXT FROM cur
			INTO @coid, @facility, @division, @managing_company, @managing_company_id
		END;

	CLOSE cur;
	DEALLOCATE cur;

	INSERT INTO @results
	SELECT *
	FROM #divsat;

	--UPDATE @results
	--SET results = (numerator / denominator) * 100
	--WHERE ISNULL(denominator, 0) > 0

	UPDATE @results
	SET target = 
		(
			SELECT results
			FROM @results
			WHERE coid = a.COID
				AND er_daily_stats_definition_id IS NULL
				AND is_target = 1              
		)
	FROM @results a
	WHERE a.er_daily_stats_definition_id IS NOT null

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


