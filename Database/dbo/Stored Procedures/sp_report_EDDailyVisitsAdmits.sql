CREATE PROCEDURE [dbo].[sp_report_EDDailyVisitsAdmits]
	(
		@report_date datetime
	)
	
AS
	SET NOCOUNT ON
  
	DECLARE @ed TABLE
		(
			coid varchar(5),
			facility varchar(50),
			same_store BIT DEFAULT 0,
			cy_mtd_ed_visits int,
			cy_mtd_ed_admits INT,
			cy_ytd_ed_visits INT,
			cy_ytd_ed_admits int,
			py_mtd_ed_visits int,
			py_mtd_ed_admits INT,
			py_ytd_ed_visits INT,
			py_ytd_ed_admits int
		);
		  
	DECLARE @month int;
	DECLARE @day int;
	DECLARE @year int;
	DECLARE @report_date_py datetime;

	SELECT @month = DATEPART(mm, @report_date);
	SELECT @day = DATEPART(dd, @report_date);
	SELECT @year = DATEPART(yyyy, @report_date);
	SELECT @report_date_py = DATEADD(yyyy, -1, @report_date);

	INSERT INTO @ed
		(
			coid, 
			facility,
			same_store
		)
	SELECT DISTINCT f.coid, f.NAME, f.SAME_STORE
	FROM Facility f WITH (NOLOCK)
		JOIN DailyERVisits visits WITH (NOLOCK)
			ON f.coid = visits.coid
				AND visits.monthno = @month
				AND visits.YEAR = @year

		JOIN DailyERAdmits admits WITH (NOLOCK)
			ON f.coid = admits.coid
				AND admits.monthno = @month
				AND admits.YEAR = @year
	WHERE f.SHOW_IN_DETAIL_REPORTS = 1
	ORDER BY f.NAME;

	UPDATE a
	SET a.cy_mtd_ed_visits = 
		(
			SELECT SUM(er_visits)
			FROM DailyERVisits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = @year
				AND monthno = @month
				AND DAY <= @day
		)
	FROM @ed a

	UPDATE a
	SET a.cy_mtd_ed_admits = 
		(
			SELECT SUM(er_admits)
			FROM DailyERAdmits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = @year
				AND monthno = @month
				AND DAY <= @day
		)
	FROM @ed a;

	UPDATE a
	SET a.cy_ytd_ed_visits = 
		(
			SELECT SUM(er_visits)
			FROM DailyERVisits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = @year
				AND er_visits_date <= @report_date
		)
	FROM @ed a

	UPDATE a
	SET a.cy_ytd_ed_admits = 
		(
			SELECT SUM(er_admits)
			FROM DailyERAdmits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = @year
				AND er_admits_date <= @report_date
		)
	FROM @ed a;

	UPDATE a
	SET a.py_mtd_ed_visits = 
		(
			SELECT SUM(er_visits)
			FROM DailyERVisits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = (@year - 1)
				AND monthno = @month
				AND DAY <= @day
				
		)
	FROM @ed a

	UPDATE a
	SET a.py_mtd_ed_admits = 
		(
			SELECT SUM(er_admits)
			FROM DailyERAdmits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = (@year - 1)
				AND monthno = @month
				AND DAY <= @day
		)
	FROM @ed a;

	UPDATE a
	SET a.py_ytd_ed_visits = 
		(
			SELECT SUM(er_visits)
			FROM DailyERVisits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = (@year - 1)
				AND er_visits_date <= @report_date_py
		)
	FROM @ed a

	UPDATE a
	SET a.py_ytd_ed_admits = 
		(
			SELECT SUM(er_admits)
			FROM DailyERAdmits WITH (NOLOCK)
			WHERE coid = a.coid
				AND YEAR = (@year - 1)
				AND er_admits_date <= @report_date_py
		)
	FROM @ed a;

	SELECT coid,
		facility,
		same_store,
		ISNULL(cy_mtd_ed_visits, 0) AS cy_mtd_ed_visits,
		ISNULL(cy_mtd_ed_admits, 0) AS cy_mtd_ed_admits,
		ISNULL(cy_ytd_ed_visits, 0) AS cy_ytd_ed_visits,
		ISNULL(cy_ytd_ed_admits, 0) AS cy_ytd_ed_admits,
		ISNULL(py_mtd_ed_visits, 0) AS py_mtd_ed_visits,
		ISNULL(py_mtd_ed_admits, 0) AS py_mtd_ed_admits,
		ISNULL(py_ytd_ed_visits, 0) AS py_ytd_ed_visits,
		ISNULL(py_ytd_ed_admits, 0) AS py_ytd_ed_admits
	FROM @ed
	ORDER BY same_store DESC, facility;

