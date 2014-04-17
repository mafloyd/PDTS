CREATE PROCEDURE [dbo].[sp_report_EDVisitsAndAdmitsMonthly]
	(
		@year int
	)
AS
begin
	SET NOCOUNT ON;

	DECLARE @ed TABLE
		(
			coid VARCHAR(5),
			facility VARCHAR(50),
			cy_jan_ed_visits INT DEFAULT 0,
			cy_feb_ed_visits INT DEFAULT 0,
			cy_mar_ed_visits INT DEFAULT 0,
			cy_apr_ed_visits INT DEFAULT 0,
			cy_may_ed_visits INT DEFAULT 0,
			cy_jun_ed_visits INT DEFAULT 0,
			cy_jul_ed_visits INT DEFAULT 0,
			cy_aug_ed_visits INT DEFAULT 0,
			cy_sep_ed_visits INT DEFAULT 0,
			cy_oct_ed_visits INT DEFAULT 0,
			cy_nov_ed_visits INT DEFAULT 0,
			cy_dec_ed_visits INT DEFAULT 0,
			cy_jan_ed_admits INT DEFAULT 0,
			cy_feb_ed_admits INT DEFAULT 0,
			cy_mar_ed_admits INT DEFAULT 0,
			cy_apr_ed_admits INT DEFAULT 0,
			cy_may_ed_admits INT DEFAULT 0,
			cy_jun_ed_admits INT DEFAULT 0,
			cy_jul_ed_admits INT DEFAULT 0,
			cy_aug_ed_admits INT DEFAULT 0,
			cy_sep_ed_admits INT DEFAULT 0,
			cy_oct_ed_admits INT DEFAULT 0,
			cy_nov_ed_admits INT DEFAULT 0,
			cy_dec_ed_admits INT DEFAULT 0,
			py_jan_ed_visits INT DEFAULT 0,
			py_feb_ed_visits INT DEFAULT 0,
			py_mar_ed_visits INT DEFAULT 0,
			py_apr_ed_visits INT DEFAULT 0,
			py_may_ed_visits INT DEFAULT 0,
			py_jun_ed_visits INT DEFAULT 0,
			py_jul_ed_visits INT DEFAULT 0,
			py_aug_ed_visits INT DEFAULT 0,
			py_sep_ed_visits INT DEFAULT 0,
			py_oct_ed_visits INT DEFAULT 0,
			py_nov_ed_visits INT DEFAULT 0,
			py_dec_ed_visits INT DEFAULT 0,
			py_jan_ed_admits INT DEFAULT 0,
			py_feb_ed_admits INT DEFAULT 0,
			py_mar_ed_admits INT DEFAULT 0,
			py_apr_ed_admits INT DEFAULT 0,
			py_may_ed_admits INT DEFAULT 0,
			py_jun_ed_admits INT DEFAULT 0,
			py_jul_ed_admits INT DEFAULT 0,
			py_aug_ed_admits INT DEFAULT 0,
			py_sep_ed_admits INT DEFAULT 0,
			py_oct_ed_admits INT DEFAULT 0,
			py_nov_ed_admits INT DEFAULT 0,
			py_dec_ed_admits INT DEFAULT 0,
			cytd_total_visits INT DEFAULT 0,
			pytd_total_visits INT DEFAULT 0,
			ytd_total_visits_variance INT DEFAULT 0,
			cytd_total_admits INT DEFAULT 0,
			pytd_total_admits INT DEFAULT 0,
			ytd_total_admits_variance INT DEFAULT 0
		)

	INSERT INTO @ed
		(
			coid,
			facility
		)
	SELECT DISTINCT
		f.coid, 
		f.NAME
	FROM Facility f WITH (NOLOCK)
		JOIN dbo.DailyERVisits er WITH (NOLOCK)
			ON f.COID = er.COID
		
		JOIN dbo.DailyERAdmits ea WITH (NOLOCK)
			ON f.coid = ea.coid
	WHERE f.SHOW_IN_DETAIL_REPORTS = 1    
	ORDER BY f.name;

	UPDATE a
	SET cy_jan_ed_visits = (SELECT sum(ER_VISITS) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND MONTHNO = 1)
	FROM @ed a

	UPDATE a
	SET cy_feb_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 2)
	FROM @ed a;

	UPDATE a
	SET cy_mar_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 3)
	FROM @ed a;

	UPDATE a
	SET cy_apr_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 4)
	FROM @ed a;

	UPDATE a
	SET cy_may_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 5)
	FROM @ed a;

	UPDATE a
	SET cy_jun_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 6)
	FROM @ed a;

	UPDATE a
	SET cy_jul_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 7)
	FROM @ed a;

	UPDATE a
	SET cy_aug_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 8)
	FROM @ed a;

	UPDATE a
	SET cy_sep_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 9)
	FROM @ed a;

	UPDATE a
	SET cy_oct_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 10)
	FROM @ed a;

	UPDATE a
	SET cy_nov_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 11)
	FROM @ed a;

	UPDATE a
	SET cy_dec_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 12)
	FROM @ed a;

	UPDATE a
	SET cy_jan_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 1)
	FROM @ed a;

	UPDATE a
	SET cy_feb_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 2)
	FROM @ed a;

	UPDATE a
	SET cy_mar_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 3)
	FROM @ed a;

	UPDATE a
	SET cy_apr_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 4)
	FROM @ed a;

	UPDATE a
	SET cy_may_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 5)
	FROM @ed a;

	UPDATE a
	SET cy_jun_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 6)
	FROM @ed a;

	UPDATE a
	SET cy_jul_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 7)
	FROM @ed a;

	UPDATE a
	SET cy_aug_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 8)
	FROM @ed a;

	UPDATE a
	SET cy_sep_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 9)
	FROM @ed a;

	UPDATE a
	SET cy_oct_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 10)
	FROM @ed a;

	UPDATE a
	SET cy_nov_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 11)
	FROM @ed a;

	UPDATE a
	SET cy_dec_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = @year AND monthno = 12)
	FROM @ed a;

	UPDATE a
	SET py_jan_ed_visits = (SELECT sum(ER_VISITS) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND MONTHNO = 1)
	FROM @ed a

	UPDATE a
	SET py_feb_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 2)
	FROM @ed a;

	UPDATE a
	SET py_mar_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 3)
	FROM @ed a;

	UPDATE a
	SET py_apr_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 4)
	FROM @ed a;

	UPDATE a
	SET py_may_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 5)
	FROM @ed a;

	UPDATE a
	SET py_jun_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 6)
	FROM @ed a;

	UPDATE a
	SET py_jul_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 7)
	FROM @ed a;

	UPDATE a
	SET py_aug_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 8)
	FROM @ed a;

	UPDATE a
	SET py_sep_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 9)
	FROM @ed a;

	UPDATE a
	SET py_oct_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 10)
	FROM @ed a;

	UPDATE a
	SET py_nov_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 11)
	FROM @ed a;

	UPDATE a
	SET py_dec_ed_visits = (SELECT SUM(er_visits) FROM dbo.DailyERVisits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 12)
	FROM @ed a;

	UPDATE a
	SET py_jan_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 1)
	FROM @ed a;

	UPDATE a
	SET py_feb_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 2)
	FROM @ed a;

	UPDATE a
	SET py_mar_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 3)
	FROM @ed a;

	UPDATE a
	SET py_apr_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 4)
	FROM @ed a;

	UPDATE a
	SET py_may_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 5)
	FROM @ed a;

	UPDATE a
	SET py_jun_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 6)
	FROM @ed a;

	UPDATE a
	SET py_jul_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 7)
	FROM @ed a;

	UPDATE a
	SET py_aug_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 8)
	FROM @ed a;

	UPDATE a
	SET py_sep_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 9)
	FROM @ed a;

	UPDATE a
	SET py_oct_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 10)
	FROM @ed a;

	UPDATE a
	SET py_nov_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 11)
	FROM @ed a;

	UPDATE a
	SET py_dec_ed_admits = (SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = a.coid AND year = (@year - 1) AND monthno = 12)
	FROM @ed a;

	IF DATEPART(yyyy, GETDATE()) = @year
		BEGIN	
			IF DATEPART(mm, GETDATE()) = 1
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0),
						pytd_total_visits = ISNULL(py_jan_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0);
				END;              
			ELSE IF DATEPART(mm, GETDATE()) = 2
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0);
				END;              
			ELSE IF DATEPART(mm, GETDATE()) = 3
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0);
				END; 
			ELSE IF DATEPART(mm, GETDATE()) = 4
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 5
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 6
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 7
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 8
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 9
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0) + ISNULL(cy_sep_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0) + ISNULL(py_sep_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0) + ISNULL(cy_sep_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0) + ISNULL(py_sep_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 10
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0) + ISNULL(cy_sep_ed_visits, 0) + ISNULL(cy_oct_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0) + ISNULL(py_sep_ed_visits, 0) + ISNULL(py_oct_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0) + ISNULL(cy_sep_ed_admits, 0) + ISNULL(cy_oct_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0) + ISNULL(py_sep_ed_admits, 0) + ISNULL(py_oct_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 11
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0) + ISNULL(cy_sep_ed_visits, 0) + ISNULL(cy_oct_ed_visits, 0) + ISNULL(cy_nov_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0) + ISNULL(py_sep_ed_visits, 0) + ISNULL(py_oct_ed_visits, 0) + ISNULL(py_nov_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0) + ISNULL(cy_sep_ed_admits, 0) + ISNULL(cy_oct_ed_admits, 0) + ISNULL(cy_nov_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0) + ISNULL(py_sep_ed_admits, 0) + ISNULL(py_oct_ed_admits, 0) + ISNULL(py_nov_ed_admits, 0);
				END;
			ELSE IF DATEPART(mm, GETDATE()) = 12
				BEGIN
					UPDATE @ed
					SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0) + ISNULL(cy_sep_ed_visits, 0) + ISNULL(cy_oct_ed_visits, 0) + ISNULL(cy_nov_ed_visits, 0) + ISNULL(cy_dec_ed_visits, 0),
						pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0) + ISNULL(py_sep_ed_visits, 0) + ISNULL(py_oct_ed_visits, 0) + ISNULL(py_nov_ed_visits, 0) + ISNULL(py_dec_ed_visits, 0),
						cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0) + ISNULL(cy_sep_ed_admits, 0) + ISNULL(cy_oct_ed_admits, 0) + ISNULL(cy_nov_ed_admits, 0) + ISNULL(cy_dec_ed_admits, 0),
						pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0) + ISNULL(py_sep_ed_admits, 0) + ISNULL(py_oct_ed_admits, 0) + ISNULL(py_nov_ed_admits, 0) + ISNULL(py_dec_ed_admits, 0);
				END;
		END;  
	ELSE
		BEGIN
			UPDATE @ed
			SET cytd_total_visits = ISNULL(cy_jan_ed_visits, 0) + ISNULL(cy_feb_ed_visits, 0) + ISNULL(cy_mar_ed_visits, 0) + ISNULL(cy_apr_ed_visits, 0) + ISNULL(cy_may_ed_visits, 0) + ISNULL(cy_jun_ed_visits, 0) + ISNULL(cy_jul_ed_visits, 0) + ISNULL(cy_aug_ed_visits, 0) + ISNULL(cy_sep_ed_visits, 0) + ISNULL(cy_oct_ed_visits, 0) + ISNULL(cy_nov_ed_visits, 0) + ISNULL(cy_dec_ed_visits, 0),
				pytd_total_visits = isnull(py_jan_ed_visits, 0) + isnull(py_feb_ed_visits, 0) + isnull(py_mar_ed_visits, 0) + ISNULL(py_apr_ed_visits, 0) + ISNULL(py_may_ed_visits, 0) + ISNULL(py_jun_ed_visits, 0) + ISNULL(py_jul_ed_visits, 0) + ISNULL(py_aug_ed_visits, 0) + ISNULL(py_sep_ed_visits, 0) + ISNULL(py_oct_ed_visits, 0) + ISNULL(py_nov_ed_visits, 0) + ISNULL(py_dec_ed_visits, 0),
				cytd_total_admits = ISNULL(cy_jan_ed_admits, 0) + ISNULL(cy_feb_ed_admits, 0) + ISNULL(cy_mar_ed_admits, 0) + ISNULL(cy_apr_ed_admits, 0) + ISNULL(cy_may_ed_admits, 0) + ISNULL(cy_jun_ed_admits, 0) + ISNULL(cy_jul_ed_admits, 0) + ISNULL(cy_aug_ed_admits, 0) + ISNULL(cy_sep_ed_admits, 0) + ISNULL(cy_oct_ed_admits, 0) + ISNULL(cy_nov_ed_admits, 0) + ISNULL(cy_dec_ed_admits, 0),
				pytd_total_admits = ISNULL(py_jan_ed_admits, 0) + ISNULL(py_feb_ed_admits, 0) + ISNULL(py_mar_ed_admits, 0) + ISNULL(py_apr_ed_admits, 0) + ISNULL(py_may_ed_admits, 0) + ISNULL(py_jun_ed_admits, 0) + ISNULL(py_jul_ed_admits, 0) + ISNULL(py_aug_ed_admits, 0) + ISNULL(py_sep_ed_admits, 0) + ISNULL(py_oct_ed_admits, 0) + ISNULL(py_nov_ed_admits, 0) + ISNULL(py_dec_ed_admits, 0);      
		END;    

	UPDATE @ed
	SET ytd_total_visits_variance = cytd_total_visits - pytd_total_visits,
		ytd_total_admits_variance = cytd_total_admits - pytd_total_admits;

	SELECT 
		coid,
		facility,
		ISNULL(cy_jan_ed_visits, 0) AS cy_jan_ed_visits,
		ISNULL(cy_feb_ed_visits, 0) AS cy_feb_ed_visits,
		ISNULL(cy_mar_ed_visits, 0) AS cy_mar_ed_visits,
		ISNULL(cy_apr_ed_visits, 0) AS cy_apr_ed_visits,
		ISNULL(cy_may_ed_visits, 0) AS cy_may_ed_visits,
		ISNULL(cy_jun_ed_visits, 0) AS cy_jun_ed_visits,
		ISNULL(cy_jul_ed_visits, 0) AS cy_jul_ed_visits,
		ISNULL(cy_aug_ed_visits, 0) AS cy_aug_ed_visits,
		ISNULL(cy_sep_ed_visits, 0) AS cy_sep_ed_visits,
		ISNULL(cy_oct_ed_visits, 0) AS cy_oct_ed_visits,
		ISNULL(cy_nov_ed_visits, 0) AS cy_nov_ed_visits,
		ISNULL(cy_dec_ed_visits, 0) AS cy_dec_ed_visits,
		ISNULL(cy_jan_ed_admits, 0) AS cy_jan_ed_admits,
		ISNULL(cy_feb_ed_admits, 0) AS cy_feb_ed_admits,
		ISNULL(cy_mar_ed_admits, 0) AS cy_mar_ed_admits,
		ISNULL(cy_apr_ed_admits, 0) AS cy_apr_ed_admits,
		ISNULL(cy_may_ed_admits, 0) AS cy_may_ed_admits,
		ISNULL(cy_jun_ed_admits, 0) AS cy_jun_ed_admits,
		ISNULL(cy_jul_ed_admits, 0) AS cy_jul_ed_admits,
		ISNULL(cy_aug_ed_admits, 0) AS cy_aug_ed_admits,
		ISNULL(cy_sep_ed_admits, 0) AS cy_sep_ed_admits,
		ISNULL(cy_oct_ed_admits, 0) AS cy_oct_ed_admits,
		ISNULL(cy_nov_ed_admits, 0) AS cy_nov_ed_admits,
		ISNULL(cy_dec_ed_admits, 0) AS cy_dec_ed_admits,
		ISNULL(py_jan_ed_visits, 0) AS py_jan_ed_visits,
		ISNULL(py_feb_ed_visits, 0) AS py_feb_ed_visits,
		ISNULL(py_mar_ed_visits, 0) AS py_mar_ed_visits,
		ISNULL(py_apr_ed_visits, 0) AS py_apr_ed_visits,
		ISNULL(py_may_ed_visits, 0) AS py_may_ed_visits,
		ISNULL(py_jun_ed_visits, 0) AS py_jun_ed_visits,
		ISNULL(py_jul_ed_visits, 0) AS py_jul_ed_visits,
		ISNULL(py_aug_ed_visits, 0) AS py_aug_ed_visits,
		ISNULL(py_sep_ed_visits, 0) AS py_sep_ed_visits,
		ISNULL(py_oct_ed_visits, 0) AS py_oct_ed_visits,
		ISNULL(py_nov_ed_visits, 0) AS py_nov_ed_visits,
		ISNULL(py_dec_ed_visits, 0) AS py_dec_ed_visits,
		ISNULL(py_jan_ed_admits, 0) AS py_jan_ed_admits,
		ISNULL(py_feb_ed_admits, 0) AS py_feb_ed_admits,
		ISNULL(py_mar_ed_admits, 0) AS py_mar_ed_admits,
		ISNULL(py_apr_ed_admits, 0) AS py_apr_ed_admits,
		ISNULL(py_may_ed_admits, 0) AS py_may_ed_admits,
		ISNULL(py_jun_ed_admits, 0) AS py_jun_ed_admits,
		ISNULL(py_jul_ed_admits, 0) AS py_jul_ed_admits,
		ISNULL(py_aug_ed_admits, 0) AS py_aug_ed_admits,
		ISNULL(py_sep_ed_admits, 0) AS py_sep_ed_admits,
		ISNULL(py_oct_ed_admits, 0) AS py_oct_ed_admits,
		ISNULL(py_nov_ed_admits, 0) AS py_nov_ed_admits,
		ISNULL(py_dec_ed_admits, 0) AS py_dec_ed_admits,
		ISNULL(ytd_total_visits_variance, 0) AS ytd_total_visits_variance,
		ISNULL(cytd_total_visits, 0) AS cytd_total_visits,
		ISNULL(pytd_total_visits, 0) AS pytd_total_visits,
		ISNULL(cytd_total_admits, 0) AS cytd_total_admits,
		ISNULL(pytd_total_admits, 0) AS pytd_total_admits
	FROM @ed
	ORDER BY facility;
END;
