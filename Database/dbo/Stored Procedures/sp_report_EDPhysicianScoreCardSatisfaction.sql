-- =============================================
-- Author:		Mike Floyd
-- Create date: 02/08/2012
-- Description:	Calculate ED Physician Scorecard
-- =============================================
CREATE PROCEDURE [dbo].[sp_report_EDPhysicianScoreCardSatisfaction]
	(
		@coid VARCHAR(5),
		@year INT,
		@question_ids VARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @top_box_answers VARCHAR(50);

	IF object_id('tempdb..#edsat') IS NOT NULL
	BEGIN
		DROP TABLE #edsat;  
	END;
	  
	DECLARE @edsat TABLE
		(
			coid VARCHAR(5),
			question_id VARCHAR(50),
			facility VARCHAR(50),
			question VARCHAR(500),
			YEAR INT,
			numerator_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			results_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_1 INT DEFAULT 0,
			numerator_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_2 INT DEFAULT 0,
			results_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			numerator_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_3 INT DEFAULT 0,
			results_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			numerator_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			results_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_4 INT DEFAULT 0,
			numerator_year DECIMAL(18, 2) DEFAULT 0,
			denominator_year DECIMAL(18, 2) DEFAULT 0,
			results_year DECIMAL(18, 2) DEFAULT 0,
			target_results DECIMAL(18, 2) DEFAULT 0,
			possible_points INT DEFAULT 0,
			isQ1Prelim BIT DEFAULT 0,
			isQ2Prelim BIT DEFAULT 0,
			isQ3Prelim BIT DEFAULT 0,
			isQ4Prelim BIT DEFAULT 0
		);

	CREATE TABLE #edsat
		(
			coid VARCHAR(5),
			question_id VARCHAR(50),
			facility VARCHAR(50),
			question VARCHAR(500),
			YEAR INT,
			numerator_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			results_quarter_1 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_1 INT DEFAULT 0,
			numerator_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_2 INT DEFAULT 0,
			results_quarter_2 DECIMAL(18, 2) DEFAULT 0,
			numerator_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_3 INT DEFAULT 0,
			results_quarter_3 DECIMAL(18, 2) DEFAULT 0,
			numerator_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			denominator_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			results_quarter_4 DECIMAL(18, 2) DEFAULT 0,
			points_quarter_4 INT DEFAULT 0,
			numerator_year DECIMAL(18, 2) DEFAULT 0,
			denominator_year DECIMAL(18, 2) DEFAULT 0,
			results_year DECIMAL(18, 2) DEFAULT 0,
			target_results DECIMAL(18, 2) DEFAULT 0,
			possible_points INT DEFAULT 0,
			isQ1Prelim BIT DEFAULT 0,
			isQ2Prelim BIT DEFAULT 0,
			isQ3Prelim BIT DEFAULT 0,
			isQ4Prelim BIT DEFAULT 0
		);

	DECLARE @question_id VARCHAR(50);
	DECLARE @sql VARCHAR(4000);

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT items FROM dbo.split(@question_ids, ',')

	OPEN cur

	FETCH NEXT FROM cur
	INTO @question_id

	WHILE @@fetch_status = 0

	BEGIN  
		SELECT @top_box_answers = TOP_BOX_ANSWERS
		FROM dbo.SURVEY_QUESTION
		WHERE data_col = @question_id;

		INSERT INTO #edsat
		        ( coid ,
		          facility ,
				  question_id,
		          question ,
		          YEAR
		        )
		SELECT
			f.coid,
			f.NAME,
			@question_id,
			(SELECT report_presentation_text FROM dbo.SURVEY_QUESTION WHERE data_col = @question_id),
			@year
		FROM dbo.Facility f WITH (NOLOCK)
		WHERE coid = @coid;
		      
		UPDATE #edsat
		SET results_quarter_1 = 
			(
				SELECT a.TOP_BOX_SCORE 
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.quarter = 1
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			points_quarter_1 = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 1
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			possible_points = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE_POSSIBLE_POINTS a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE coid = @coid
					AND year = @year
					AND b.DATA_COL = @question_id
			),
			isQ1Prelim = 
			(
				SELECT a.PRELIMINARY
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 1
					AND a.year = @year
					AND b.data_col = @question_id
			)
		WHERE #edsat.question_id = @question_id

		UPDATE #edsat
		SET results_quarter_2 = 
			(
				SELECT a.TOP_BOX_SCORE 
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.quarter = 2
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			points_quarter_2 = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 2
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			possible_points = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE_POSSIBLE_POINTS a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE coid = @coid
					AND year = @year
					AND b.DATA_COL = @question_id
			),
			isQ2Prelim = 
			(
				SELECT a.PRELIMINARY
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 2
					AND a.year = @year
					AND b.data_col = @question_id
			)
		WHERE #edsat.question_id = @question_id

		UPDATE #edsat
		SET results_quarter_3 = 
			(
				SELECT a.TOP_BOX_SCORE 
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.quarter = 3
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			points_quarter_3 = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 3
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			possible_points = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE_POSSIBLE_POINTS a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE coid = @coid
					AND year = @year
					AND b.DATA_COL = @question_id
			),
			isQ3Prelim = 
			(
				SELECT a.PRELIMINARY
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 3
					AND a.year = @year
					AND b.data_col = @question_id
			)
		WHERE #edsat.question_id = @question_id

		UPDATE #edsat
		SET results_quarter_4 = 
			(
				SELECT a.TOP_BOX_SCORE 
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.quarter = 4
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			points_quarter_4 = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 4
					AND a.year = @year
					AND b.DATA_COL = @question_id
			),
			possible_points = 
			(
				SELECT a.points
				FROM dbo.ER_TOP_BOX_SCORE_POSSIBLE_POINTS a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE coid = @coid
					AND year = @year
					AND b.DATA_COL = @question_id
			),
			isQ4Prelim = 
			(
				SELECT a.PRELIMINARY
				FROM dbo.ER_TOP_BOX_SCORE a WITH (NOLOCK)
					JOIN dbo.SURVEY_QUESTION b WITH (NOLOCK)
						ON a.QUESTION_ID = b.QUESTION_ID
				WHERE a.coid = @coid
					AND a.QUARTER = 4
					AND a.year = @year
					AND b.data_col = @question_id
			)
		WHERE #edsat.question_id = @question_id

		FETCH NEXT FROM cur
		INTO @question_id;  
	END;  

	CLOSE cur;
	DEALLOCATE cur;

	INSERT INTO @edsat
	SELECT *
	FROM #edsat

	UPDATE @edsat
	SET numerator_year = numerator_quarter_1 + numerator_quarter_2 + numerator_quarter_3 + numerator_quarter_4,
		denominator_year = denominator_quarter_1 + denominator_quarter_2 + denominator_quarter_3 + denominator_quarter_4;

	UPDATE @edsat
	SET results_year = numerator_year / denominator_year
	WHERE denominator_year <> 0;

	UPDATE a
	SET a.target_results = 
		(
			SELECT sqt.target
			FROM dbo.SURVEY_QUESTION sq WITH (NOLOCK)
				JOIN dbo.SURVEY_QUESTION_TARGET sqt WITH (NOLOCK)
					ON sq.QUESTION_ID = sqt.QUESTION_ID
			WHERE sq.DATA_COL = a.QUESTION_ID
				AND sqt.coid = a.coid
				AND sqt.year = @year
		)
	FROM @edsat a

	UPDATE @edsat
	SET isQ1Prelim = 0
	WHERE isQ1Prelim IS NULL;

	UPDATE @edsat
	SET isQ2Prelim = 0
	WHERE isQ2Prelim IS NULL;

	UPDATE @edsat
	SET isQ3Prelim = 0
	WHERE isQ3Prelim IS NULL;

	UPDATE @edsat
	SET isQ4Prelim = 0
	WHERE isQ4Prelim IS NULL;

	update @edsat
	set results_quarter_1 = 0
	where results_quarter_1 is null

	update @edsat
	set points_quarter_1 = 0
	where points_quarter_1 is null

	update @edsat
	set results_quarter_2 = 0
	where results_quarter_2 is null

	update @edsat
	set points_quarter_2 = 0
	where points_quarter_2 is null

	update @edsat
	set results_quarter_3 = 0
	where results_quarter_3 is null

	update @edsat
	set points_quarter_3 = 0
	where points_quarter_3 is null

	update @edsat
	set results_quarter_4 = 0
	where results_quarter_4 is null

	update @edsat
	set points_quarter_4 = 0
	where points_quarter_4 is null

	update @edsat
	set target_results = 0
	where target_results is null;

	SELECT *
	FROM @edsat;
END
