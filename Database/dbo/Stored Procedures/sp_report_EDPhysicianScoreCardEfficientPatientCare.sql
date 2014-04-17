
CREATE PROCEDURE [dbo].[sp_report_EDPhysicianScoreCardEfficientPatientCare]
	(
		@coid VARCHAR(5),
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;
  
	DECLARE @q1 DECIMAL(10, 2)

	DECLARE @hq TABLE
		(
			stats_id INT,
			coid VARCHAR(5),
			facility VARCHAR(50),
			measure VARCHAR(100),
			is_percentage BIT,
			rollup_is_average BIT,
			goal VARCHAR(100),
			YEAR INT,
			jan DECIMAL(10, 2) DEFAULT 0,
			feb DECIMAL(10, 2) DEFAULT 0,
			mar DECIMAL(10, 2) DEFAULT 0,
			q1 DECIMAL(10,2) DEFAULT 0,
			apr DECIMAL(10, 2) DEFAULT 0,
			may DECIMAL(10, 2) DEFAULT 0,
			jun DECIMAL(10, 2) DEFAULT 0,
			q2 DECIMAL(10, 2) DEFAULT 0,
			jul DECIMAL(10, 2) DEFAULT 0,
			aug DECIMAL(10, 2) DEFAULT 0,
			sep DECIMAL(10, 2) DEFAULT 0,
			q3 DECIMAL(10, 2) DEFAULT 0,
			oct DECIMAL(10, 2) DEFAULT 0,
			nov DECIMAL(10, 2) DEFAULT 0,
			DEC DECIMAL(10, 2) DEFAULT 0,
			q4 decimal(10, 2) DEFAULT 0,
			ytd decimal(10, 2) DEFAULT 0,
			compare_goal DECIMAL(10, 2) DEFAULT 0,
			q1points INT DEFAULT 0,
			q2points INT DEFAULT 0,
			q3points INT DEFAULT 0,
			q4points INT DEFAULT 0,
			possible_points INT DEFAULT 0
		);

	INSERT INTO @hq
	(
		stats_id,
		coid,
		facility,
		measure,
		is_percentage,
		rollup_is_average,
		goal,
		compare_goal
	)
	SELECT distinct
		t.ER_DAILY_STATS_DEFINITION_ID,
		f.coid,
		f.name,
		LTRIM(RTRIM(REPLACE(t.name, 'Target', ''))),
		1,
		1,
		'<1.5%',
		1.5
	FROM Facility f WITH (NOLOCK)
		JOIN dbo.ER_DAILY_STATS_DEFINITION t
				on t.ER_DAILY_STATS_DEFINITION_ID in (17)
	WHERE f.coid = @coid;  

	UPDATE a
	SET a.jan = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 1 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.feb = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 2 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.mar = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 3 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.apr = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 4  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.may = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 5  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.jun = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 6  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.jul = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 7  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.aug = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 8  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.sep = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 9  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.oct = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 10  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.nov = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 11  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0),
		a.dec = ISNULL((SELECT SUM(total) FROM ER_DAILY_ENTRY WHERE coid = @coid AND month = 12  AND year = @year AND ER_DAILY_STATS_DEFINITION_ID IN (8, 9)), 0)
	FROM @hq a

	INSERT INTO @hq
		(
			stats_id,
			coid,
			facility,
			measure,
			is_percentage,
			rollup_is_average,
			goal,
			compare_goal
		)
	SELECT distinct
		t.ER_DAILY_STATS_DEFINITION_ID,
		f.coid,
		f.name,
		LTRIM(RTRIM(REPLACE(t.name, 'Target', ''))),
		0,
		1,
		CAST(t.target AS INT),
		t.target
	FROM Facility f WITH (NOLOCK)
		JOIN dbo.ER_DAILY_STATS_DEFINITION_TARGET t
			ON f.COID = t.COID
				AND t.ER_DAILY_STATS_DEFINITION_ID in (2, 4, 37)
				AND t.year = @year
	WHERE f.coid = @coid;  

	UPDATE a
	SET jan = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 1 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		feb = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 2 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		mar = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 3 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		apr = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 4 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		may = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 5 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		jun = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 6 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		jul = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 7 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		aug = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 8 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		sep = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 9 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		oct = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 10 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		nov = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 11 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		dec = ISNULL((SELECT average FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 12 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0)
	FROM @hq a
	WHERE stats_id <> 17;

	UPDATE a
	SET q1points = ISNULL((SELECT points FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 3 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		q2points = ISNULL((SELECT points FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 6 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		q3points = ISNULL((SELECT points FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 9 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0),
		q4points = ISNULL((SELECT points FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK) WHERE coid = @coid AND month = 12 AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0)
	FROM @hq a;

	UPDATE a
	SET possible_points = ISNULL((SELECT points FROM dbo.ER_DAILY_STATS_POSSIBLE_POINTS WITH (NOLOCK) WHERE coid = @coid AND year = @year AND ER_DAILY_STATS_DEFINITION_ID = a.stats_id), 0)
	FROM @hq a;

	SELECT *
	FROM @hq;
END;

