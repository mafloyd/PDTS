CREATE PROCEDURE [dbo].[sp_report_DailyFlashMcareAcuteAdmissions]
    (
        @divisionId int = 0,
        @reportDate DATETIME,
		@qtd BIT = 0
    )
AS
BEGIN
	SET NOCOUNT ON;
    
    declare @summary table
        (
            coid varchar(5),
            facility_name varchar(100),
            same_store bit,
            top_ten bit,
            top_ten_sort_order int default 0,
            division_id int,
            division varchar(50),
            admits INT,
			include_in_flash_totals BIT DEFAULT 1,
			flash_rollup_to_coid varchar(5)
        );
     
    if @divisionId = 1
        begin
        insert into @summary (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division, include_in_flash_totals, flash_rollup_to_coid)
            select coid, f.short_name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name, f.INCLUDE_IN_FLASH_TOTALS, f.flash_rollup_to_coid
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
        insert into @summary (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division, include_in_flash_totals, flash_rollup_to_coid)
            select coid, f.short_name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name, f.INCLUDE_IN_FLASH_TOTALS, f.flash_rollup_to_coid
            from facility f with (nolock)
                join division d with (nolock)
                    on f.division_id = d.division_id    
            where f.active = 1
                and f.division_id = @divisionId
                and f.show_in_detail_reports = 1
            order by coid;
        end
    
	IF @qtd = 0
		begin
			update s
			set s.admits = (
								select isnull(sum(admits), 0)
								from DailyMcareAcuteAdmits WITH (NOLOCK)
								where coid = s.coid
									and year = datepart(yyyy, @reportDate)
									and monthno = datepart(mm, @reportDate)
									and day <= datepart(dd, @reportDate)
							)
			from @summary s;
		END;
	ELSE IF @qtd = 1
		BEGIN
			update s
			set s.admits = (
								select isnull(sum(admits), 0)
								from DailyMcareAcuteAdmits WITH (NOLOCK)
								where coid = s.coid
									and year = datepart(yyyy, @reportDate)
									AND quarter = DATEPART(q, @reportDate)
							)
			from @summary s;      
		END;      
    
	declare @coid varchar(5)
	declare @flash_rollup_to_coid varchar(5)
	declare @admits int

	declare cur cursor fast_forward read_only for
	select coid, flash_rollup_to_coid, admits
	from @summary s
	where flash_rollup_to_coid is not null

	open cur

	fetch next from cur
	into @coid, @flash_rollup_to_coid, @admits

	while @@fetch_status = 0
		begin
			update @summary
			set admits = admits + @admits
			where coid = @flash_rollup_to_coid;

			fetch next from cur
			into @coid, @flash_rollup_to_coid, @admits
		end;

	close cur;
	deallocate cur;
    select *
    from @summary
    order by facility_name
END

