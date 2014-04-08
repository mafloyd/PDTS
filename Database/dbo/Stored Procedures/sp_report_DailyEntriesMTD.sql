CREATE PROCEDURE [dbo].[sp_report_DailyEntriesMTD]
	(
		@coid VARCHAR(5),
		@month INT,
		@year INT
	)
AS
BEGIN
	DECLARE @t TABLE
		(
			coid VARCHAR(5),
			admits INT DEFAULT 0,
			inpatient INT DEFAULT 0,
			outpatient INT DEFAULT 0,
			census INT DEFAULT 0,
			deliveries INT DEFAULT 0,
			er_admits INT DEFAULT 0,
			er_visits INT DEFAULT 0,
			op_visits INT DEFAULT 0,
			cath_lab_procs INT DEFAULT 0,
			mcare_admits INT DEFAULT 0,
			mcare_pat_days INT DEFAULT 0,
			obs_visits INT DEFAULT 0,
			op_charges DECIMAL(18, 2) DEFAULT 0
		);  

	INSERT INTO @t (coid)
	VALUES (@coid)

	UPDATE @t
	SET admits = ISNULL((SELECT SUM(admits) FROM DailyAdmissions WITH (NOLOCK) WHERE coid = @coid AND MONTHNO = @month AND year = @year), 0);

	UPDATE @t
	SET inpatient = ISNULL((SELECT SUM(IP) FROM dbo.DailySurgeries WITH (NOLOCK) WHERE coid = @coid AND MONTHNO = @month AND year = @year), 0);

	UPDATE @t
	SET outpatient = ISNULL((SELECT SUM(OUTP) FROM dbo.DailySurgeries WITH (NOLOCK) WHERE coid = @coid AND MONTHNO = @month AND year = @year), 0);

	UPDATE @t
	SET census = ISNULL((SELECT SUM(census) FROM dbo.DailyCensus WITH (NOLOCK) WHERE coid = @coid AND MONTHNO = @month AND year = @year), 0);

	UPDATE @t
	SET deliveries = ISNULL((SELECT SUM(deliveries) FROM dbo.DailyDeliveries WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET er_admits = ISNULL((SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET er_visits = ISNULL((SELECT SUM(er_admits) FROM dbo.DailyERAdmits WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET op_visits = ISNULL((SELECT SUM(op_visits) FROM dbo.DailyOPVisits WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET cath_lab_procs = ISNULL((SELECT SUM(cath_lab_procedures) FROM dbo.DailyCardiacCathLabProcs WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET mcare_admits = ISNULL((SELECT SUM(admits) FROM dbo.DailyMcareAcuteAdmits WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET mcare_pat_days = ISNULL((SELECT SUM(pat_days) FROM dbo.DailyMcareAcutePatDays WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET obs_visits = ISNULL((SELECT SUM(obs_visits) FROM DailyObsVisits WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	UPDATE @t
	SET op_charges = ISNULL((SELECT SUM(op_charges) FROM dbo.DailyOPCharges WITH (NOLOCK) WHERE coid = @coid AND monthno = @month AND year = @year), 0);

	SELECT *
	FROM @t;
END;

