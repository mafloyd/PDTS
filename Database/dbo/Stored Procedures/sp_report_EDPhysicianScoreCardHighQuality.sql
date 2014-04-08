
CREATE PROCEDURE [dbo].[sp_report_EDPhysicianScoreCardHighQuality]
	(
		@coid VARCHAR(5),
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;
  
	DECLARE @hq TABLE
		(
			coid VARCHAR(5),
			facility VARCHAR(50),
			measure VARCHAR(100),
			is_calculated BIT,
			rollup_is_average BIT,
			goal VARCHAR(100),
			YEAR INT,
			q1results DECIMAL(10,2) DEFAULT 0,
			q2results DECIMAL(10, 2) DEFAULT 0,
			q3results DECIMAL(10, 2) DEFAULT 0,
			q4results decimal(10, 2) DEFAULT 0,
			ytd decimal(10, 2) DEFAULT 0,
			compare_goal DECIMAL(5, 2),
			compare_direction VARCHAR(1),
			q1points INT DEFAULT 0,
			q2points INT DEFAULT 0,
			q3points INT DEFAULT 0,
			q4points INT DEFAULT 0,
			possible_points INT DEFAULT 0,
			q1ispreliminary BIT DEFAULT 0,
			q2ispreliminary BIT DEFAULT 0,
			q3ispreliminary BIT DEFAULT 0,
			q4ispreliminary BIT DEFAULT 0
		);

	DECLARE @er_daily_stat_definition_id VARCHAR(50);
	DECLARE @sql VARCHAR(4000);
	DECLARE @currentYear INT;
	DECLARE @currentMonth INT;  
	DECLARE @q1totalhours INT;
	DECLARE @q1locumshours INT;
	DECLARE @q2totalhours INT;
	DECLARE @q2locumshours INT;
	DECLARE @q3totalhours INT;
	DECLARE @q3locumshours INT
	DECLARE @q4totalhours INT;
	DECLARE @q4locumshours INT;  

	SELECT @currentYear = DATEPART(yyyy, GETDATE());
	SELECT @currentMonth = DATEPART(mm, GETDATE());

	INSERT INTO @hq
	        ( coid ,
	          facility ,
	          measure ,
	          is_calculated ,
	          rollup_is_average ,
	          goal ,
	          YEAR,
			  compare_goal,
			  compare_direction
	        )
	SELECT 
		@coid,
		f.name,
		'ED Core Measure Performance (* denotes preliminary)',
		0,
		0,
		'9/9',
		2013,
		9,
		'>'
	FROM Facility f WITH (NOLOCK)
	WHERE f.coid = @coid;

	UPDATE @hq
	SET possible_points = ISNULL((SELECT points FROM dbo.ER_CORE_MEASURE_POSSIBLE_POINTS WHERE coid = @coid AND year = @year), 0);

	UPDATE @hq
	SET q1results = ISNULL((SELECT score FROM ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 3 AND year = @year), 0),
		q1points = ISNULL((SELECT points FROM dbo.ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 3 AND year = @year), 0),
		q1ispreliminary = ISNULL((SELECT is_preliminary from er_core_measure with (NOLOCK) where coid = @coid AND month = 3 AND year = @year), 0);

	UPDATE @hq
	SET q2results = ISNULL((SELECT score FROM ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 6 AND year = @year), 0),
		q2points = ISNULL((SELECT points FROM ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 6 AND year = @year), 0),
		q2ispreliminary = ISNULL((SELECT is_preliminary from er_core_measure with (NOLOCK) where coid = @coid AND month = 6 AND year = @year), 0);

	UPDATE @hq
	SET q3results = ISNULL((SELECT score FROM ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 9 AND year = @year), 0),
		q3points = ISNULL((SELECT points FROM dbo.ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 9 AND year = @year), 0),
		q3ispreliminary = ISNULL((SELECT is_preliminary from er_core_measure with (NOLOCK) where coid = @coid AND month = 9 AND year = @year), 0);

	UPDATE @hq
	SET q4results = ISNULL((SELECT score FROM ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 12 AND year = @year), 0),
		q4points = ISNULL((SELECT points FROM dbo.ER_CORE_MEASURE WITH (NOLOCK) WHERE coid = @coid AND month = 12 AND year = @year), 0),
		q4ispreliminary = ISNULL((SELECT is_preliminary from er_core_measure with (NOLOCK) where coid = @coid AND month = 12 AND year = @year), 0);

	INSERT INTO @hq
	        ( coid ,
	          facility ,
	          measure ,
	          is_calculated ,
	          rollup_is_average ,
	          goal ,
	          YEAR, 
			  compare_goal,
			  compare_direction
	        )
	SELECT 
		@coid,
		f.name,
		'Locum hours as % of total provider hours (Source: Group)',
		1,
		0,
		'<= 15%',
		2013,
		15.0,
		'<'
	FROM Facility f WITH (NOLOCK)
	WHERE f.coid = @coid;

	UPDATE @hq
	SET possible_points = ISNULL((SELECT points FROM dbo.ER_DAILY_STATS_POSSIBLE_POINTS WHERE coid = @coid AND year = @year and er_daily_stats_definition_id = 46), 0)
	where measure = 'Locum hours as % of total provider hours (Source: Group)';

	SELECT @q1totalhours = (SELECT SUM(total) FROM ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 113 AND year = @year AND MONTH IN (1, 2, 3));
	SELECT @q1locumshours = (SELECT SUM(total) FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_ENTRY_ID = 112 AND year = @year AND month IN (1, 2, 3));

	SELECT @q2totalhours = (SELECT SUM(total) FROM ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 113 AND year = @year AND MONTH IN (4, 5, 6));
	SELECT @q2locumshours = (SELECT SUM(total) FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_ENTRY_ID = 112 AND year = @year AND month IN (4, 5, 6));

	SELECT @q3totalhours = (SELECT SUM(total) FROM ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 113 AND year = @year AND MONTH IN (7, 8, 9));
	SELECT @q3locumshours = (SELECT SUM(total) FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 112 AND year = @year AND month IN (7, 8, 9));

	SELECT @q4totalhours = (SELECT SUM(total) FROM ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 113 AND year = @year AND MONTH IN (10, 11, 12));
	SELECT @q4locumshours = (SELECT SUM(total) FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND ER_DAILY_STATS_DEFINITION_ID = 112 AND year = @year AND month IN (10, 11, 12));

	IF @q1totalhours > 0
		BEGIN
			UPDATE @hq 
			SET q1results = isnull(CAST(@q1locumshours AS DECIMAL(6, 2)) / CAST(@q1totalhours AS DECIMAL(6, 2)), 0)
			WHERE measure = 'Locum hours as % of total provider hours (Source: Group)'       
		END;      

	IF @q2totalhours > 0
		BEGIN
			UPDATE @hq 
			SET q2results = isnull(CAST(@q2locumshours AS DECIMAL(6, 2)) / CAST(@q2totalhours AS DECIMAL(6, 2)), 0)
			WHERE measure = 'Locum hours as % of total provider hours (Source: Group)'       
		END; 
		     
	IF @q3totalhours > 0
		BEGIN
			UPDATE @hq 
			SET q3results = ISNULL(CAST(@q3locumshours AS DECIMAL(6, 2)) / CAST(@q3totalhours AS DECIMAL(6, 2)), 0)
			WHERE measure = 'Locum hours as % of total provider hours (Source: Group)'       
		END;      

	IF @q4totalhours > 0
		BEGIN
			UPDATE @hq 
			SET q4results = isnull(CAST(@q4locumshours AS DECIMAL(6, 2)) / CAST(@q4totalhours AS DECIMAL(6, 2)), 0)
			WHERE measure = 'Locum hours as % of total provider hours (Source: Group)'       
		END;      
	
	SELECT *
	FROM @hq;
END;

