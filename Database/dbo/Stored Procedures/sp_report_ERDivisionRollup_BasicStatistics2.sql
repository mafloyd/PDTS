CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_BasicStatistics2]
	(
		@division_id INT,
		@YEAR int,
		@MONTH INT,
		@edm_managing_company_id INT = 0,
		@daily bit = 0
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @coid varchar(5);
	DECLARE @facility VARCHAR(50);
	DECLARE @division_id_cur INT;
	DECLARE @division VARCHAR(50);
	DECLARE @managing_company VARCHAR(50);
	DECLARE @managing_company_id INT;

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
			numerator_stat_id INT,
			edm_managing_company_id INT,
			division_id int
		);

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT DISTINCT f.coid, f.name, d.name, e.name, e.EDM_MANAGING_COMPANY_ID, d.DIVISION_ID
	FROM dbo.Facility f WITH (NOLOCK)
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
				AND f.SHOW_IN_DETAIL_REPORTS = 1

		LEFT JOIN dbo.EDM_MANAGING_COMPANY e WITH (NOLOCK)
			ON f.EDM_MANAGING_COMPANY_ID = e.EDM_MANAGING_COMPANY_ID
	ORDER BY f.name;

	OPEN cur;

	FETCH NEXT FROM cur 
	INTO @coid, @facility, @division, @managing_company, @managing_company_id, @division_id_cur

	WHILE @@fetch_status = 0
		BEGIN      
			DECLARE @total int;

			-- to obs
			SELECT @total = a.total
			FROM dbo.ER_DAILY_ENTRY a WITH (NOLOCK)
			WHERE a.coid = @coid
				AND a.ER_DAILY_STATS_DEFINITION_ID = 11
				AND a.MONTH = @month
				AND a.year = @year;

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
					numerator_stat_id,
					edm_managing_company_id,
					division_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				@total,
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.NUMERATOR_STAT_ID,
				@managing_company_id,
				@division_id_cur
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = 11; 

			-- percent admits
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
					numerator_stat_id,
					edm_managing_company_id,
					division_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				0,
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.NUMERATOR_STAT_ID,
				@managing_company_id,
				@division_id_cur
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = 18; 

			-- percent obs
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
					numerator_stat_id,
					edm_managing_company_id,
					division_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				0,
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.NUMERATOR_STAT_ID,
				@managing_company_id,
				@division_id_cur
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = 19; 

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
					numerator_stat_id,
					edm_managing_company_id,
					division_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				b.total,
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.NUMERATOR_STAT_ID,
				@managing_company_id,
				@division_id_cur
			FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
				JOIN dbo.ER_DAILY_ENTRY b WITH (NOLOCK)
					ON a.ER_DAILY_STATS_DEFINITION_ID = b.ER_DAILY_STATS_DEFINITION_ID
			WHERE b.coid = @coid
				AND b.ER_DAILY_STATS_DEFINITION_ID = 12
				AND b.MONTH = @month
				AND b.year = @year;

			-- percent transferred
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
					numerator_stat_id,
					edm_managing_company_id,
					division_id
				)
			SELECT 
				@coid,
				@facility,
				a.ER_DAILY_STATS_DEFINITION_ID,
				a.NAME,
				0,
				a.SORT_ORDER,
				a.DIVISION_ROLLUP_SORT_ORDER,
				@division,
				a.IS_CALCULATED,
				@managing_company,
				a.NUMERATOR_STAT_ID,
				@managing_company_id,
				@division_id_cur
			FROM dbo.ER_DAILY_STATS_DEFINITION a
			WHERE ER_DAILY_STATS_DEFINITION_ID = 20; 

			IF @daily = 1
				BEGIN
					SELECT @total = SUM(er_visits)
					FROM dbo.DailyERVisits a WITH (NOLOCK)
					WHERE a.coid = @coid
						AND a.year = @year        
						AND a.MONTHNO = @month
						
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
							numerator_stat_id,
							edm_managing_company_id,
							division_id
						)
					SELECT 
						@coid,
						@facility,
						a.ER_DAILY_STATS_DEFINITION_ID,
						a.NAME,
						@total,
						a.SORT_ORDER,
						a.DIVISION_ROLLUP_SORT_ORDER,
						@division,
						a.IS_CALCULATED,
						@managing_company,
						a.NUMERATOR_STAT_ID,
						@managing_company_id,
						@division_id_cur
					FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
					WHERE a.ER_DAILY_STATS_DEFINITION_ID = 15

					SELECT @total = SUM(er_admits)
					FROM dbo.DailyERAdmits a WITH (NOLOCK)
					WHERE a.coid = @coid
						AND a.year = @year        
						AND a.MONTHNO = @month
						
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
							numerator_stat_id,
							edm_managing_company_id,
							division_id
						)
					SELECT 
						@coid,
						@facility,
						a.ER_DAILY_STATS_DEFINITION_ID,
						a.NAME,
						@total,
						a.SORT_ORDER,
						a.DIVISION_ROLLUP_SORT_ORDER,
						@division,
						a.IS_CALCULATED,
						@managing_company,
						a.NUMERATOR_STAT_ID,
						@managing_company_id,
						@division_id_cur
					FROM dbo.ER_DAILY_STATS_DEFINITION a WITH (NOLOCK)
					WHERE a.ER_DAILY_STATS_DEFINITION_ID = 10
				END;

			FETCH NEXT FROM cur
			INTO @coid, @facility, @division, @managing_company,  @managing_company_id, @division_id_cur
		END;

	CLOSE cur;
	DEALLOCATE cur;

	IF @edm_managing_company_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE ISNULL(edm_managing_company_id, 0) <> @edm_managing_company_id;      
		END;      

	IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id      
		END;      
	SELECT *
	FROM @results
	ORDER BY facility, division_rollup_sort_order;
END

