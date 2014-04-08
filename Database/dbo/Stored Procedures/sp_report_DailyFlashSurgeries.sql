CREATE PROCEDURE [dbo].[sp_report_DailyFlashSurgeries]
    (
        @divisionId int = 0,
        @reportDate DATETIME,
		@qtd BIT = 0
    )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @beginMonth INT
	DECLARE @endMonth int  
    
    declare @summary table
        (
            coid varchar(5),
            facility_name varchar(100),
            same_store bit,
            top_ten bit,
            top_ten_sort_order int default 0,
            division_id int,
            division varchar(50),
            inpatient int,
            outpatient int,
            total_surgeries int,
            budget_inpatient int,
            budget_outpatient int,
            budget_total int,
            py_inpatient int,
            py_outpatient int,
            py_total int,
            pm_inpatient int,
            pm_outpatient int,
            pm_total INT,
			include_in_flash_totals BIT DEFAULT 1,
			flash_rollup_to_coid varchar(5)
        );
     
	IF DATEPART(q, @reportDate) = 1
		BEGIN
			SELECT @beginMonth = 1;
			SELECT @endMonth = 3;      
		END;
	ELSE IF DATEPART(q, @reportDate) = 2
		BEGIN
			SELECT @beginMonth = 4;
			SELECT @beginMonth = 6;      
		END;      
	ELSE IF DATEPART(q, @reportDate) = 3
		BEGIN
			SELECT @beginMonth = 7;
			SELECT @endMonth = 9;      
		END;      
	ELSE IF DATEPART(q, @reportDate) = 4
		BEGIN
			SELECT @beginMonth = 10;
			SELECT @beginMonth = 12;      
		END;      
		      
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
			set s.inpatient =  (
								select isnull(sum(ip), 0)
								from DailySurgeries with (nolock)
								where coid = s.coid
									and year = datepart(yyyy, @reportDate)
									and monthno = datepart(mm, @reportDate)
									and day <= datepart(dd, @reportDate)
							   )
			from @summary s;
		END;
    ELSE
		BEGIN
			update s
			set s.inpatient =  (
								select isnull(sum(ip), 0)
								from DailySurgeries with (nolock)
								where coid = s.coid
									and year = datepart(yyyy, @reportDate)
									and quarter = datepart(q, @reportDate)
							   )
			from @summary s;      
		END;  

	IF @qtd = 0
		begin
			update s
			set s.outpatient =  (
								select isnull(sum(outp), 0)
								from DailySurgeries with (nolock)
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
			set s.outpatient =  (
								select isnull(sum(outp), 0)
								from DailySurgeries with (nolock)
								where coid = s.coid
									and year = datepart(yyyy, @reportDate)
									and quarter = datepart(q, @reportDate)
							   )
			from @summary s;      
		END;      
    
    update s
    set s.budget_inpatient = (
                                    select isnull(sum(inpatient), 0)
                                    from provider p with (nolock)
                                        join BudgetYear_Surgery bys with (nolock)
                                            on p.pdts_provider_id = bys.pdts_provider_id
                                    where p.coid = s.coid
                                        and bys.year = datepart(yyyy, @reportDate)
                                        and bys.monthno = datepart(mm, @reportDate)
                                )
    from @summary s;
    
    update s
    set s.budget_outpatient =   (
                                    select isnull(sum(outpatient), 0)
                                    from provider p with (nolock)
                                        join BudgetYear_Surgery bys with (nolock)
                                            on p.pdts_provider_id = bys.pdts_provider_id
                                    where p.coid = s.coid
                                        and bys.year = datepart(yyyy, @reportDate)
                                        and bys.monthno = datepart(mm, @reportDate)
                                )
    from @summary s;
    
	IF @qtd = 0
		begin
			update s
			set s.py_inpatient = (
									select isnull(sum(inpatient), 0)
									from provider p with (nolock)
										join CurrentYear_Surgery cys with (nolock)
											on p.pdts_provider_id = cys.pdts_provider_id
									where p.coid = s.coid
										and cys.year = datepart(yyyy, @reportDate) - 1
										and cys.monthno = datepart(mm, @reportDate)
								 )
			from @summary s;
		END;
	ELSE IF @qtd = 1
		BEGIN
			update s
			set s.py_inpatient = (
									select isnull(sum(inpatient), 0)
									from provider p with (nolock)
										join CurrentYear_Surgery cys with (nolock)
											on p.pdts_provider_id = cys.pdts_provider_id
									where p.coid = s.coid
										and cys.year = datepart(yyyy, @reportDate) - 1
										and cys.MONTHNO BETWEEN @beginMonth AND @endMonth
								 )
			from @summary s;      
		END;      
    
	IF @qtd = 0
		BEGIN
			update s
			set s.py_outpatient = (
									select isnull(sum(outpatient), 0)
									from provider p with (nolock)
										join CurrentYear_Surgery cys with (nolock)
											on p.pdts_provider_id = cys.pdts_provider_id
									where p.coid = s.coid
										and cys.year = datepart(yyyy, @reportDate) - 1
										and cys.monthno = datepart(mm, @reportDate)
								  )
			from @summary s;
		END;
	ELSE IF @qtd = 1
		BEGIN
			update s
			set s.py_outpatient = (
									select isnull(sum(outpatient), 0)
									from provider p with (nolock)
										join CurrentYear_Surgery cys with (nolock)
											on p.pdts_provider_id = cys.pdts_provider_id
									where p.coid = s.coid
										and cys.year = datepart(yyyy, @reportDate) - 1
										and cys.monthno BETWEEN @beginMonth AND @endMonth
								  )
			from @summary s;      
		END;      
    
    if datepart(mm, @reportDate) = 1
        begin
            update s
            set s.pm_inpatient =    (
                                        select isnull(sum(inpatient), 0)
                                        from provider p with (nolock)
                                            join CurrentYear_Surgery cys with (nolock)
                                                on p.pdts_provider_id = cys.pdts_provider_id
                                        where p.coid = s.coid
                                            and cys.year = datepart(yyyy, @reportDate) - 1
                                            and cys.monthno = 12
                                    )
            from @summary s;
                                    
            update s
            set s.pm_outpatient =   (
                                        select isnull(sum(outpatient), 0)
                                        from provider p with (nolock)
                                            join CurrentYear_Surgery cys with (nolock)
                                                on p.pdts_provider_id = cys.pdts_provider_id
                                        where p.coid = s.coid
                                            and cys.year = datepart(yyyy, @reportDate) - 1
                                            and cys.monthno = 12
                                    )
            from @summary s;
        end
    else
        begin       
            update s
            set s.pm_inpatient =    (
                                        select isnull(sum(cys.inpatient), 0)
                                        from provider p with (nolock)
                                            join CurrentYear_Surgery cys with (nolock)
                                                on p.pdts_provider_id = cys.pdts_provider_id
                                        where p.coid = s.coid
                                            and cys.year = datepart(yyyy, @reportDate)
                                            and cys.monthno = (datepart(mm, @reportDate) - 1)
                                    )
            from @summary s;
                                    
            update s
            set s.pm_outpatient =   (
                                        select isnull(sum(outpatient), 0)
                                        from provider p with (nolock)
                                            join CurrentYear_Surgery cys with (nolock)
                                                on p.pdts_provider_id = cys.pdts_provider_id
                                        where p.coid = s.coid
                                            and cys.year = datepart(yyyy, @reportDate)
                                            and cys.monthno = datepart(mm, @reportDate) - 1
                                    )
            from @summary s;
        end;
     
	declare @coid varchar(5)
	declare @flash_rollup_to_coid varchar(5)
	declare @inpatient int
	declare @outpatient int
	declare @py_inpatient int
	declare @py_outpatient int
	
	declare cur cursor fast_forward read_only for
	select coid, flash_rollup_to_coid, inpatient, outpatient, py_inpatient, py_outpatient
	from @summary s
	where flash_rollup_to_coid is not null;
	
	open cur

	fetch next from cur
	into @coid, @flash_rollup_to_coid, @inpatient, @outpatient, @py_inpatient, @py_outpatient

	while @@fetch_status = 0
		begin
			update @summary
			set inpatient = inpatient + @inpatient,
				outpatient = outpatient + @outpatient,
				py_inpatient = py_inpatient + @py_inpatient,
				py_outpatient = py_outpatient + @py_outpatient
			where coid = @flash_rollup_to_coid;

			fetch next from cur
			into @coid, @flash_rollup_to_coid, @inpatient, @outpatient, @py_inpatient, @py_outpatient
		end;
		
	close cur
	deallocate cur;
	   
	UPDATE @summary
	SET inpatient = 0,
		outpatient = 0,
		total_surgeries = 0,
		budget_inpatient = 0,
		budget_outpatient = 0,
		budget_total = 0,
		py_inpatient = 0,
		py_outpatient = 0,
		py_total = 0,
		pm_inpatient = 0,
		pm_outpatient = 0,
		pm_total = 0
	WHERE flash_rollup_to_coid is not null;

    update @summary
    set total_surgeries = isnull(inpatient, 0) + isnull(outpatient, 0),
        budget_total = isnull(budget_inpatient, 0) + isnull(budget_outpatient, 0),
        py_total = isnull(py_inpatient, 0) + isnull(py_outpatient, 0),
        pm_total = isnull(pm_inpatient, 0) + isnull(pm_outpatient, 0)

	UPDATE @summary
	SET
		inpatient = inpatient + (SELECT inpatient FROM @summary WHERE coid = '02751'),
		outpatient = outpatient + (SELECT outpatient FROM @summary WHERE coid = '02751'),
		total_surgeries = total_surgeries + (SELECT total_surgeries FROM @summary WHERE coid ='02751'),
		budget_inpatient = budget_inpatient + (SELECT budget_inpatient FROM @summary WHERE coid = '02751'),
		budget_outpatient = budget_outpatient + (SELECT budget_outpatient FROM @summary WHERE coid = '02751'),
		budget_total = budget_total + (SELECT budget_total FROM @summary WHERE coid = '02751'),
		py_inpatient = py_inpatient + (SELECT py_inpatient FROM @summary WHERE coid = '02751'),
		py_outpatient = py_outpatient + (SELECT py_outpatient FROM @summary WHERE coid = '02751'),
		py_total = py_total + (SELECT py_total FROM @summary WHERE coid = '02751'),
		pm_inpatient = pm_inpatient + (SELECT pm_inpatient FROM @summary WHERE coid = '02751'),
		pm_outpatient = pm_outpatient + (SELECT pm_outpatient FROM @summary WHERE coid = '02751'),
		pm_total = pm_total + (SELECT pm_total FROM @summary WHERE coid = '02751')
	WHERE coid = '05470'

	UPDATE @summary
	SET inpatient = 0,
		outpatient = 0,
		total_surgeries = 0,
		budget_inpatient = 0,
		budget_outpatient = 0,
		budget_total = 0,
		py_inpatient = 0,
		py_outpatient = 0,
		py_total = 0,
		pm_inpatient = 0,
		pm_outpatient = 0,
		pm_total = 0
	WHERE coid = '02751';
	  
    select *
    from @summary
    order by facility_name
END

