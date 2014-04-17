CREATE PROCEDURE [dbo].[sp_report_DailyFlashReport]
    (
        @divisionId int = 0,
        @reportDate DATETIME,
		@qtd BIT = 0,
		@ytd BIT = 0,
		@table sysname,
		@column sysname
    )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(4000);
	DECLARE @year INT;
	DECLARE @month INT;
	DECLARE @day INT;
	DECLARE @quarter INT;
    
	IF object_id('tempdb..#flash') IS NOT NULL
		BEGIN
			DROP TABLE #flash;      
		END;  

	CREATE TABLE #flash
		(
			coid varchar(5),
            facility_name varchar(100),
            same_store bit,
            top_ten bit,
            top_ten_sort_order int default 0,
            division_id int,
            division varchar(50),
            volume INT,
			include_in_flash_totals BIT DEFAULT 1,
			budget_equal_runrate_when_zero BIT DEFAULT 0,
			flash_rollup_to_coid varchar(5)
		);

    declare @flash table
        (
            coid varchar(5),
            facility_name varchar(100),
            same_store bit,
            top_ten bit,
            top_ten_sort_order int default 0,
            division_id int,
            division varchar(50),
            op_visits INT,
			include_in_flash_totals BIT DEFAULT 1,
			budget_equal_runrate_when_zero BIT DEFAULT 0,
			flash_rollup_to_coid varchar(5)
        );
     
    if @divisionId = 1
        begin
			insert into #flash (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division, include_in_flash_totals, budget_equal_runrate_when_zero, flash_rollup_to_coid)
            select coid, f.short_name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name, f.INCLUDE_IN_FLASH_TOTALS, f.BUDGET_EQUAL_RUNRATE_WHEN_ZERO, f.flash_rollup_to_coid
            from facility f with (nolock)
                join division d with (nolock)
                    on f.division_id = d.division_id    
            where f.active = 1
                and f.division_id is not null
                and f.show_in_detail_reports = 1
            order by coid;
        end
    else if @divisionId > 1
        begin
			insert into #flash (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division, include_in_flash_totals, budget_equal_runrate_when_zero, flash_rollup_to_coid)
            select coid, f.short_name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name, f.INCLUDE_IN_FLASH_TOTALS, f.BUDGET_EQUAL_RUNRATE_WHEN_ZERO, f.flash_rollup_to_coid
            from facility f with (nolock)
                join division d with (nolock)
                    on f.division_id = d.division_id    
            where f.active = 1
                and f.division_id = @divisionId
                and f.show_in_detail_reports = 1
            order by coid;
        end
    
	SELECT @year = DATEPART(yyyy, @reportDate);
	SELECT @month = DATEPART(mm, @reportDate);
	SELECT @day = DATEPART(dd, @reportDate);
	SELECT @quarter = DATEPART(q, @reportDate);

	IF @qtd = 0 AND @ytd = 0
		BEGIN
			SELECT @sql = 'update s ';
			SELECT @sql = @sql + 'set s.volume = ( ';
			SELECT @sql = @sql + 'select isnull(sum(' + @column + '), 0) ';
			SELECT @sql = @sql + 'from ' + @table + ' with (nolock) ';
			SELECT @sql = @sql + 'where coid = s.coid ';
			SELECT @sql = @sql + 'and year = ' + CAST(@year AS VARCHAR(4)) + ' ';
			SELECT @sql = @sql + 'and monthno = ' + CAST(@month AS VARCHAR(2)) + ' ';
			SELECT @sql = @sql + 'and day <= ' + CAST(@day AS VARCHAR(2)) + ') ';
			SELECT @sql = @sql + 'from #flash s';
		END;
	ELSE IF @qtd = 1
		BEGIN
			SELECT @sql = 'UPDATE s ';
			SELECT @sql = @sql + 'SET s.volume = (';
			SELECT @sql = @sql + 'SELECT ISNULL(SUM(' + @column + '), 0) ';
			SELECT @sql = @sql + 'FROM ' + @table + ' WITH (NOLOCK) ';
			SELECT @sql = @sql + 'WHERE coid = s.coid ';
			SELECT @sql = @sql + 'AND year = ' + CAST(@year AS VARCHAR(4)) + ' ';
			SELECT @sql = @sql + 'AND quarter = ' + CAST(@quarter AS VARCHAR(1)) + ') ';
			SELECT @sql = @sql + 'FROM #flash s ';
		END;  
	ELSE IF @ytd = 1
		BEGIN
			SELECT @sql = 'UPDATE s ';
			SELECT @sql = @sql + 'SET s.volume = (';
			SELECT @sql = @sql + 'SELECT ISNULL(SUM(' + @column + '), 0) ';
			SELECT @sql = @sql + 'FROM ' + @table + ' WITH (NOLOCK) ';
			SELECT @sql = @sql + 'WHERE coid = s.coid ';
			SELECT @sql = @sql + 'AND year = ' + CAST(@year AS VARCHAR(4)) + ') ';
			SELECT @sql = @sql + 'FROM #flash s ';
		END;      
    
	EXEC (@sql);

	INSERT INTO @flash
	SELECT *
	FROM #flash;

	declare @coid varchar(5)
	declare @flash_rollup_to_coid varchar(5)
	declare @op_visits int

	declare cur cursor fast_forward read_only for
	select coid, flash_rollup_to_coid, op_visits
	from @flash s
	where flash_rollup_to_coid is not null

	open cur

	fetch next from cur
	into @coid, @flash_rollup_to_coid, @op_visits

	while @@fetch_status = 0
		begin
			update @flash
			set op_visits = op_visits + @op_visits
			where coid = @flash_rollup_to_coid;

			fetch next from cur
			into @coid, @flash_rollup_to_coid, @op_visits
		end;

	close cur;
	deallocate cur;

    select *
    from @flash
    order by facility_name
END

