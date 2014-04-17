CREATE PROCEDURE [dbo].[sp_report_EDMonthlySingleFacility]
	(
		@coid VARCHAR(5),
		@year INT,
		@month int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		f.name AS facility,
		b.name AS metric, 
		a.ER_DAILY_STATS_DEFINITION_ID,
		a.day_1, 
		a.day_2, 
		a.day_3, 
		a.day_4, 
		a.day_5, 
		a.day_6, 
		a.day_7, 
		a.day_8, 
		a.day_9, 
		a.day_10, 
		a.day_11, 
		a.day_12, 
		a.day_13, 
		a.day_14, 
		a.day_15, 
		a.day_16,
		a.day_17,
		a.day_18,
		a.day_19,
		a.day_20,
		a.day_21,
		a.day_22,
		a.day_23,
		a.day_24,
		a.day_25,
		a.day_26,
		a.day_27,
		a.day_28,
		a.day_29,
		a.day_30,
		a.day_31,
		a.TOTAL, 
		a.AVERAGE,
		b.IS_CALCULATED,
		b.BACKGROUND,
		(
			SELECT target 
			FROM dbo.ER_DAILY_STATS_DEFINITION_TARGET 
			WHERE coid = @coid 
				AND ER_DAILY_STATS_DEFINITION_ID = a.ER_DAILY_STATS_DEFINITION_ID 
				AND month = a.month 
				AND year = a.year
		) AS facility_target,
		b.COMPARE_GOAL
	FROM dbo.ER_DAILY_ENTRY a WITH (NOLOCK)
		JOIN dbo.ER_DAILY_STATS_DEFINITION b WITH (NOLOCK)
			ON a.ER_DAILY_STATS_DEFINITION_ID = b.ER_DAILY_STATS_DEFINITION_ID

		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.coid
	WHERE a.coid = @coid
		AND a.year = @year
		AND a.month = @month
		AND b.ACTIVE_FOR_UI = 1
	ORDER BY b.SORT_ORDER
END

