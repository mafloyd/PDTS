

CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_SingleStat]
	(
		@division_id INT,
		@YEAR int,
		@MONTH INT,
		@er_daily_stats_definition_id int
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @coid varchar(5);
	DECLARE @facility VARCHAR(50);
	DECLARE @division VARCHAR(50);
	DECLARE @managing_company VARCHAR(50);

    DECLARE @results TABLE
		(
			coid varchar(5),
			facility varchar(50),
			er_daily_stats_definition_id INT,
			stat_definition varchar(50),
			total int,
			sort_order int,
			division_rollup_sort_order int,
			division VARCHAR(50),
			is_calculated bit,
			managing_company varchar(50),
			goal VARCHAR(50)
		);

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT DISTINCT f.coid, f.name, d.name, e.name
	FROM dbo.Facility f WITH (NOLOCK)
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
				AND d.DIVISION_ID = @division_id
				AND f.SHOW_IN_DETAIL_REPORTS = 1

		LEFT JOIN dbo.EDM_MANAGING_COMPANY e WITH (NOLOCK)
			ON f.EDM_MANAGING_COMPANY_ID = e.EDM_MANAGING_COMPANY_ID
	ORDER BY f.name;

	OPEN cur;

	FETCH NEXT FROM cur 
	INTO @coid, @facility, @division, @managing_company

	WHILE @@fetch_status = 0
		BEGIN      
			DECLARE @total int;
			SELECT @total = 0;


			-- ALOS
			SELECT @total = DAY_1 + DAY_2 + DAY_3 + DAY_4 + DAY_5 + DAY_7 + DAY_8 + DAY_9 + DAY_10 + DAY_11 + DAY_12 + DAY_13 + DAY_14 + DAY_15 + DAY_16 + DAY_17 + DAY_18 + DAY_19 +
				DAY_20 + DAY_21 + DAY_22 + DAY_23 + DAY_24 + DAY_25 + DAY_26 + DAY_27 + DAY_28 + DAY_29 + DAY_30 + DAY_31
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id
				AND YEAR = @year
				AND MONTH = @month;
				
			INSERT INTO @results
				(
					coid,
					facility,
					er_daily_stats_definition_id,
					stat_definition,
					total,
					sort_order,
					division_rollup_sort_order,
					division,
					is_calculated,
					managing_company,
					goal
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				ISNULL(@total, 0),
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.goal
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = @er_daily_stats_definition_id; 

			FETCH NEXT FROM cur
			INTO @coid, @facility, @division, @managing_company
		END;

	CLOSE cur;
	DEALLOCATE cur;

	SELECT *
	FROM @results
	ORDER BY facility, sort_order;
END



