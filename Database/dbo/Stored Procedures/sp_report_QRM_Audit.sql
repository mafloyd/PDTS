CREATE PROCEDURE [dbo].[sp_report_QRM_Audit]
	(
		@reporting_period_month INT,
		@reporting_period_year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @audit TABLE
		(
			coid VARCHAR(5),
			facility VARCHAR(50),
			measure VARCHAR(250),
			VALUE int
		);

	INSERT INTO @audit
		(
			coid,
			facility,
			measure,
			value
		)
	SELECT 
		f.coid,
		f.NAME,
		qt.NAME,
		q.VALUE
	FROM dbo.Facility f WITH (NOLOCK)
		LEFT JOIN QRM_MEASURE q WITH (NOLOCK)
			ON f.coid = q.coid
				AND q.REPORTING_PERIOD_MONTH = @reporting_period_month
				AND q.REPORTING_PERIOD_YEAR = @reporting_period_year
		
		LEFT JOIN dbo.QRM_MEASURE_TYPE qt WITH (NOLOCK)
			ON q.QRM_MEASURE_TYPE_ID = qt.QRM_MEASURE_TYPE_ID     
	WHERE f.DIVISION_ID IS NOT NULL
		AND ACTIVE = 1
		AND f.coid NOT IN ('05456', '05430', '16826', '05342', '16816', '16286', '16815', '16812', '16814', '16818', '16813', '16905', '16819', '05352', '16832', '16831', '16833',
			'16882', '16883', '16884', '16169', '16655')

	SELECT *
	FROM @audit
	ORDER BY facility;
END

