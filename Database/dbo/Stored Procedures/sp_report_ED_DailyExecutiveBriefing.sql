
CREATE PROCEDURE [dbo].[sp_report_ED_DailyExecutiveBriefing]
	(
		@report_date datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @month INT
	DECLARE @year INT
	DECLARE @day INT  
	DECLARE @report_date_minus_one_year DATETIME;
	  
	SELECT @month = DATEPART(mm, @report_date);
	SELECT @year = DATEPART(yyyy, @report_date);
	SELECT @day = DATEPART(dd, @report_date);
	SELECT @report_date_minus_one_year = DATEADD(yyyy, -1, @report_date);

    DECLARE @ed TABLE
		(
			division_id INT,
			division_name VARCHAR(50),
			stat_id INT,
			stat VARCHAR(50),
			cy_mtd DECIMAL(18, 4) DEFAULT 0,
			py_mtd DECIMAL(18, 4) DEFAULT 0,
			cytd DECIMAL(18, 4) DEFAULT 0,
			pytd DECIMAL(18, 4) DEFAULT 0,
			sort_order INT,
			percentage BIT DEFAULT 0
		)

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		100,
		'Admissions',
		100
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 100;

	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 100;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 100;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 100;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.same_store = 1
				AND b.Year = @year
				AND b.ADMISSIONS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 100;

	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.ADMISSIONS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 100;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = (@year - 1) 
				AND b.ADMISSIONS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 100;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.admits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyAdmissions b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.ADMISSIONS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 100;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		200,
		'Patient Days',
		200
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.CENSUS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 200;

	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 200;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.same_store = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 200;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 200;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				and b.Year = @year
				AND b.CENSUS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 200;

	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.CENSUS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 200;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = (@year - 1) 
				AND b.CENSUS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 200;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.census) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyCensus b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.CENSUS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 200;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		300,
		'ER Visits',
		300
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.ER_VISITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 300;

	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 300;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 300;

	UPDATE a
	SET a.py_mtd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 300;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.ER_VISITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 300;

	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.ER_VISITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 300;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = (@year - 1) 
				AND b.ER_VISITS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 300;

	UPDATE a
	SET a.pytd = 
		(
			SELECT SUM(b.er_visits) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = (@year - 1)
				AND b.ER_VISITS_DATE <= @report_date_minus_one_year
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 300;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		400,
		'Observation Visits',
		400
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.OBS_VISITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyObsVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 400;

	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.OBS_VISITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyObsVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 400;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.OBS_VISITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyObsVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.OBS_VISITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 400;

	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.OBS_VISITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyObsVisits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.OBS_VISITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 400;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		500,
		'ER Admits',
		500
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.ER_ADMITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERAdmits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 500;

	UPDATE a
	SET a.cy_mtd = 
		(
			SELECT SUM(b.ER_ADMITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERAdmits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.MONTHNO = @month
				AND b.day <= @day
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 500;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.ER_ADMITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERAdmits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.SAME_STORE = 1
				AND b.Year = @year
				AND b.ER_ADMITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id = 1
		AND stat_id = 500;

	UPDATE a
	SET a.cytd = 
		(
			SELECT SUM(b.ER_ADMITS) 
			FROM facility f WITH (NOLOCK) 
				JOIN dbo.DailyERAdmits b WITH (NOLOCK) 
					ON f.coid = b.coid
			WHERE f.division_id = a.division_id
				AND f.SAME_STORE = 1
				AND b.Year = @year
				AND b.ER_ADMITS_DATE <= @report_date
		)
	FROM @ed a
	WHERE division_id > 1
		AND stat_id = 500;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order
		)
	SELECT division_id,
		name,
		700,
		'Total Admits & Obs',
		700
	FROM division WITH (NOLOCK);

	-- Month To Date Numbers
	UPDATE a
	SET a.cy_mtd = 
		(
			(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) + 
			(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400)
		)
	FROM @ed a
	WHERE stat_id = 700;

	UPDATE a
	SET a.py_mtd = 
		(
			(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) + 
			(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400)	
		)
	FROM @ed a
	WHERE stat_id = 700;

	-- YTD Numbers
	UPDATE a
	SET a.cytd = 
		(
			(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) + 
			(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400)	
		)
	FROM @ed a
	WHERE stat_id = 700;

	UPDATE a
	SET a.pytd = 
		(
			(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) + 
			(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400)	
		)
	FROM @ed a
	WHERE stat_id = 700;
	
	--INSERT INTO @ed
	--	(
	--		division_id,
	--		division_name,          
	--		stat_id,
	--		stat,
	--		sort_order
	--	)
	--SELECT division_id,
	--	name,
	--	800,
	--	'Total ER Admits & Obs',
	--	800
	--FROM division WITH (NOLOCK);

	---- Month To Date Numbers
	--UPDATE a
	--SET a.cy_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) + 
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)
	--	)
	--FROM @ed a
	--WHERE stat_id = 800;

	--UPDATE a
	--SET a.py_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) + 
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 800;

	---- YTD Numbers
	--UPDATE a
	--SET a.cytd = 
	--	(
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) + 
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 800;

	--UPDATE a
	--SET a.pytd = 
	--	(
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) + 
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 800;

	--INSERT INTO @ed
	--	(
	--		division_id,
	--		division_name,          
	--		stat_id,
	--		stat,
	--		sort_order
	--	)
	--SELECT division_id,
	--	name,
	--	550,
	--	'ER Observations',
	--	550
	--FROM division WITH (NOLOCK);

	---- Month To Date Numbers
	--UPDATE a
	--SET a.cy_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) -
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)
	--	)
	--FROM @ed a
	--WHERE stat_id = 550;

	--UPDATE a
	--SET a.py_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) -
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 550;

	---- YTD Numbers
	--UPDATE a
	--SET a.cytd = 
	--	(
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) -
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 550;

	--UPDATE a
	--SET a.pytd = 
	--	(
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) -
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500)	
	--	)
	--FROM @ed a
	--WHERE stat_id = 550;

	--UPDATE a
	--SET a.cy_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) + 
	--		(SELECT ISNULL(SUM(cy_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 550)
	--	)
	--FROM @ed a
	--WHERE a.stat_id = 800

	--UPDATE a
	--SET a.py_mtd = 
	--	(
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) + 
	--		(SELECT ISNULL(SUM(py_mtd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 550)
	--	)
	--FROM @ed a
	--WHERE a.stat_id = 800

	--UPDATE a
	--SET a.cytd = 
	--	(
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) + 
	--		(SELECT ISNULL(SUM(cytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 550)
	--	)
	--FROM @ed a
	--WHERE a.stat_id = 800

	--UPDATE a
	--SET a.pytd = 
	--	(
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) + 
	--		(SELECT ISNULL(SUM(pytd), 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 550)
	--	)
	--FROM @ed a
	--WHERE a.stat_id = 800

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order,
			percentage
		)
	SELECT division_id,
		name,
		900,
		'ER Admits as % of Total Admits',
		900,
		1
	FROM division WITH (NOLOCK);
	
	UPDATE a
	SET a.cy_mtd =
		(
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) AS DECIMAL(18, 4)))
		),
		a.py_mtd = 
		(
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) AS DECIMAL(18, 4)))
		),
		a.cytd = 
		(
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) AS DECIMAL(18, 4)))
		),
		a.pytd = 
		(
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 100) AS DECIMAL(18, 4)))
		)
	FROM @ed a
	WHERE stat_id = 900;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order,
			percentage
		)
	SELECT division_id,
		name,
		1000,
		'ER Admit Rate',
		1000,
		1
	FROM division WITH (NOLOCK);
	
	UPDATE a
	SET a.cy_mtd =
		(
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
		),
		a.py_mtd = 
		(
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
		),
		a.cytd = 
		(
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
		),
		a.pytd = 
		(
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 500) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
		)
	FROM @ed a
	WHERE stat_id = 1000;

	--INSERT INTO @ed
	--	(
	--		division_id,
	--		division_name,          
	--		stat_id,
	--		stat,
	--		sort_order,
	--		percentage
	--	)
	--SELECT division_id,
	--	name,
	--	1100,
	--	'ER Admits & Obs as % of Total Admits and Obs',
	--	1100,
	--	1
	--FROM division WITH (NOLOCK);
	
	--UPDATE a
	--SET a.cy_mtd =
	--	(
	--		(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
	--	),
	--	a.py_mtd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
	--	),
	--	a.cytd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
	--	),
	--	a.pytd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
	--	)
	--FROM @ed a
	--WHERE stat_id = 1100;

	--INSERT INTO @ed
	--	(
	--		division_id,
	--		division_name,          
	--		stat_id,
	--		stat,
	--		sort_order,
	--		percentage
	--	)
	--SELECT division_id,
	--	name,
	--	1200,
	--	'ER Admit & Obs Rate',
	--	1200,
	--	1
	--FROM division WITH (NOLOCK);
	
	--UPDATE a
	--SET a.cy_mtd =
	--	(
	--		(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
	--	),
	--	a.py_mtd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
	--	),
	--	a.cytd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
	--	),
	--	a.pytd = 
	--	(
	--		(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 800) AS DECIMAL(18, 4))) /
	--		(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 300) AS DECIMAL(18, 4)))
	--	)
	--FROM @ed a
	--WHERE stat_id = 1200;

	INSERT INTO @ed
		(
			division_id,
			division_name,          
			stat_id,
			stat,
			sort_order,
			percentage
		)
	SELECT division_id,
		name,
		1300,
		'Obs as % of Total Obs and Admits',
		1300,
		1
	FROM division WITH (NOLOCK);
	
	UPDATE a
	SET a.cy_mtd =
		(
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cy_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
		),
		a.py_mtd = 
		(
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(py_mtd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
		),
		a.cytd = 
		(
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(cytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
		),
		a.pytd = 
		(
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 400) AS DECIMAL(18, 4))) /
			(SELECT CAST((SELECT ISNULL(pytd, 0) FROM @ed WHERE division_id = a.division_id AND stat_id = 700) AS DECIMAL(18, 4)))
		)
	FROM @ed a
	WHERE stat_id = 1300;

	UPDATE @ed
	SET division_name = 'LifePoint'
	WHERE division_id = 1;

	SELECT *
	FROM @ed;
END

