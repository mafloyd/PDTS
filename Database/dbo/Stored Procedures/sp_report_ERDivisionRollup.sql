CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup]
	(
		@year INT,
		@month INT,
		@division_id int
	)
AS
BEGIN
	SELECT 
		a.coid, 
		b.NAME AS facility, 
		c.ER_DAILY_STATS_DEFINITION_ID, 
		c.name AS stat_definition,
		(DAY_1 + DAY_2 + DAY_3 + DAY_4 + DAY_5 + DAY_7 + DAY_8 + DAY_9 + DAY_10 + DAY_11 + DAY_12 + DAY_13 + DAY_14 + DAY_15 + DAY_16 + DAY_17 + DAY_18 + DAY_19 +
		DAY_20 + DAY_21 + DAY_22 + DAY_23 + DAY_24 + DAY_25 + DAY_26 + DAY_27 + DAY_28 + DAY_29 + DAY_30 + DAY_31) as total,
		c.sort_order,
		c.division_rollup_sort_order,
		d.name as division
	FROM ER_DAILY_ENTRY a WITH (NOLOCK)
		JOIN facility b WITH (NOLOCK)
			ON a.coid = b.COID

		JOIN dbo.ER_DAILY_STATS_DEFINITION c WITH (NOLOCK)
			ON a.ER_DAILY_STATS_DEFINITION_ID = c.ER_DAILY_STATS_DEFINITION_ID
		join dbo.DIVISION d with (nolock)
			on b.division_id = d.division_id
	WHERE b.division_id = @division_id
		and a.year = @year
		AND a.month = @month
		AND a.ER_DAILY_STATS_DEFINITION_ID IN (15, 18, 19, 20)
	ORDER BY b.name, c.DIVISION_ROLLUP_SORT_ORDER
END

