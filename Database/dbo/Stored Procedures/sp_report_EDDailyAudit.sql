CREATE PROCEDURE [dbo].[sp_report_EDDailyAudit]
	(
		@report_date datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		f.coid, 
		f.NAME, 
		def.name AS stat, 
		ISNULL(er.day_1, 0) AS day_1,
		ISNULL(er.day_2, 0) AS day_2, 
		ISNULL(er.day_3, 0) AS day_3,
		ISNULL(er.day_4, 0) AS day_4,
		ISNULL(er.day_5, 0) AS day_5,
		ISNULL(er.day_6, 0) AS day_6, 
		ISNULL(er.day_7, 0) AS day_7, 
		ISNULL(er.day_8, 0) AS day_8, 
		ISNULL(er.day_9, 0) AS day_9, 
		ISNULL(er.day_10, 0) AS day_10, 
		ISNULL(er.day_11, 0) AS day_11, 
		ISNULL(er.day_12, 0) AS day_12, 
		ISNULL(er.day_13, 0) AS day_13, 
		ISNULL(er.day_14, 0) AS day_14, 
		ISNULL(er.day_15, 0) AS day_15,
		ISNULL(er.day_16, 0) AS day_16, 
		ISNULL(er.day_17, 0) AS day_17, 
		ISNULL(er.day_18, 0) AS day_18, 
		ISNULL(er.day_19, 0) AS day_19, 
		ISNULL(er.day_20, 0) AS day_20, 
		ISNULL(er.day_21, 0) AS day_21, 
		ISNULL(er.day_22, 0) AS day_22, 
		ISNULL(er.day_23, 0) AS day_23, 
		ISNULL(er.day_24, 0) AS day_24, 
		ISNULL(er.day_25, 0) AS day_25, 
		ISNULL(er.day_26, 0) AS day_26, 
		ISNULL(er.day_27, 0) AS day_27, 
		ISNULL(er.day_28, 0) AS day_28, 
		ISNULL(er.day_29, 0) AS day_29, 
		ISNULL(er.day_30, 0) AS day_30,
		ISNULL(er.day_31, 0) AS day_31
	FROM Facility f WITH (NOLOCK)
		LEFT JOIN dbo.ER_DAILY_ENTRY er WITH (NOLOCK)
			ON f.COID = er.COID
				and er.YEAR = DATEPART(yyyy, @report_date)
				AND er.MONTH = DATEPART(mm, @report_date)
				AND er.ER_DAILY_STATS_DEFINITION_ID = 15

		LEFT JOIN dbo.ER_DAILY_STATS_DEFINITION def WITH (NOLOCK)
			ON er.ER_DAILY_STATS_DEFINITION_ID = def.ER_DAILY_STATS_DEFINITION_ID
	WHERE f.active = 1
		AND f.SHOW_IN_DETAIL_REPORTS = 1
	ORDER BY f.name;
END

