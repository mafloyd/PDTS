CREATE PROCEDURE [dbo].[sp_report_DailySummary]
    (
        @year int,
        @monthno smallint,
        @day smallint,
        @sameStore bit = 0,
        @top_ten bit = 0,
        @top_ten_list bit = 0,
        @new_operations bit = 0
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
			new_store BIT DEFAULT 0,
            admissions int,
            census int,
            deliveries int,
            er_admits int,
            er_visits int,
            op_visits int,
            surgeries int default 0,
            budgetAdmissions int,
            priorYearAdmissions int,
            budgetSurgeries int,
            priorYearSurgeries INT,
			op_charges DECIMAL(18, 2),
			top_ten_list BIT,
			group_coid VARCHAR(5),
			include_with_group bit
        );
     
	DECLARE @prev_year INT;

	SELECT @prev_year = @year - 1;

    insert into @summary (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division, new_store, top_ten_list, group_coid, include_with_group)
    select coid, f.name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name, ISNULL(f.NEW_STORE, 0), f.TOP_TEN_LIST, f.group_coid, f.include_with_group
    from facility f with (nolock)
        join division d with (nolock)
            on f.division_id = d.division_id
        
    where f.active = 1
        and f.division_id is not null
    order by coid;
        
    update s
    set s.admissions = (
                        select isnull(sum(admits), 0)
                        from DailyAdmissions WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                 )
    from @summary s;
    
    update s
    set s.census = (
                        select isnull(sum(census), 0)
                        from DailyCensus WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                    )
    from @summary s;
    
    update s
    set s.deliveries = (
                        select isnull(sum(deliveries), 0)
                        from DailyDeliveries WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                       )
    from @summary s;
                        
    update s
    set s.er_admits = (
                        select isnull(sum(er_admits), 0)
                        from DailyERAdmits WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                      )
    from @summary s;
    
    update s
    set s.er_visits = (
                        select isnull(sum(er_visits), 0)
                        from DailyERVisits WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                         )
    from @summary s;
    
    update s
    set s.op_visits = (
                        select isnull(sum(op_visits), 0)
                        from DailyOPVisits WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno 
                            and day <= @day
                      )
    from @summary s;
    
    update s
    set s.surgeries = (
                        select isnull(sum(isnull(ip, 0) + isnull(outp, 0)), 0)
                        from DailySurgeries WITH (NOLOCK)
                        where coid = s.coid
                            and year = @year
                            and monthno = @monthno
                            and day <= @day
                      )
    from @summary s;
    
    --update s
    --set s.budgetAdmissions = (
    --                            select isnull(sum(b.admits), 0)
    --                            from provider p with (nolock)
    --                                join BudgetYear_Admit b with (nolock)
    --                                    on p.pdts_provider_id = b.pdts_provider_id
    --                            where p.coid = s.coid
    --                                and b.year = @year
    --                                and b.monthno = @monthno
    --                         )
    --from @summary s;
    
	UPDATE s
	SET s.budgetAdmissions = (
								SELECT ISNULL(SUM(b.admits), 0)
								FROM Provider p WITH (NOLOCK)
									JOIN dbo.BudgetYear_Admit b WITH (NOLOCK)
										ON p.coid = s.coid
											AND p.pdts_provider_id = b.PDTS_PROVIDER_ID
								WHERE b.year = @year
									AND b.monthno = @monthno
							 )
	FROM @summary s;
    update s
    set s.priorYearAdmissions = (
                                    select isnull(sum(b.admits), 0)
                                    from provider p with (nolock)
                                            join CurrentYear_Admit b with (nolock)
                                            on p.pdts_provider_id = b.pdts_provider_id
                                    where p.coid = s.coid
                                        and b.year = @year - 1
                                        and b.monthno = @monthno
                                )
    from @summary s;
    
    update s
    set s.budgetSurgeries = (
                                select isnull(sum(b.inpatient + b.outpatient), 0)
                                from provider p with (nolock)
                                    join BudgetYear_Surgery b with (nolock)
                                        on p.pdts_provider_id = b.pdts_provider_id
                                where p.coid = s.coid
                                    and b.year = @year
                                    and b.monthno = @monthno
                            )
    from @summary s;
    
    --update s
    --set s.priorYearSurgeries = (
    --                                select isnull(sum(b.inpatient + b.outpatient), 0)
    --                                from provider p with (nolock)
    --                                    join CurrentYear_Surgery b with (nolock)
    --                                        on p.pdts_provider_id = b.pdts_provider_id
    --                                where p.coid = s.coid
    --                                    and b.year = @year - 1
    --                                    and b.monthno = @monthno
    --                            )
    --from @summary s;

	update s
    set s.priorYearSurgeries = (
                                    select isnull(sum(b.inpatient + b.outpatient), 0)
                                    from provider p with (nolock)
                                        join CurrentYear_Surgery b with (nolock)
											ON p.coid = s.coid
												AND p.pdts_provider_id = b.pdts_provider_id
                                    where b.year = @prev_year
                                        and b.monthno = @monthno
                                )
    from @summary s;

	UPDATE s
	SET s.op_charges = (
							SELECT ISNULL(SUM(op_charges), 0)
							FROM DailyOPCharges WITH (NOLOCK)
							where coid = s.coid
								and year = @year
								and monthno = @monthno
								and day <= @day
						)
	FROM @summary s;
	
	IF @top_ten_list = 1 OR @top_ten = 1
		BEGIN
			DECLARE @coid VARCHAR(5)
			      
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT group_coid
			FROM @summary
			WHERE include_with_group = 1
			
			OPEN cur
			
			FETCH NEXT FROM cur
			INTO @coid;        
			
			WHILE @@fetch_status = 0
				BEGIN
					UPDATE @summary
					SET surgeries = surgeries + (SELECT SUM(surgeries) FROM @summary WHERE group_coid = @coid AND include_with_group = 1),
						budgetSurgeries = budgetSurgeries + (SELECT SUM(budgetSurgeries) FROM @summary WHERE group_coid = @coid AND include_with_group = 1),
						priorYearSurgeries = priorYearSurgeries + (SELECT SUM(priorYearSurgeries) FROM @summary WHERE group_coid = @coid AND include_with_group = 1),
						op_charges = op_charges + (SELECT SUM(op_charges) FROM @summary WHERE group_coid = @coid AND include_with_group = 1)
					WHERE coid = @coid;
					
					              
					FETCH NEXT FROM cur
					INTO @coid;              
				END;
				
			CLOSE cur
			deallocate cur;  
		END;
		      
    if (@samestore = 1)
        begin
            select isnull(sum(admissions), 0) as admissions,
                isnull(sum(census), 0) as census,
                isnull(sum(deliveries), 0) as deliveries,
                isnull(sum(er_admits), 0) as er_admits,
                isnull(sum(er_visits), 0) as er_visits,
                isnull(sum(op_visits), 0) as op_visits,
                sum(isnull(surgeries, 0)) as surgeries,
                isnull(sum(budgetAdmissions), 0) as budgetAdmissions,
                isnull(sum(priorYearAdmissions), 0) as priorYearAdmissions,
                isnull(sum(budgetSurgeries), 0) as budgetSurgeries,
                isnull(sum(priorYearSurgeries), 0) as priorYearSurgeries,
				ISNULL(SUM(op_charges), 0) AS op_charges
            from @summary
            where same_store = 1;
        end
    --else if (@top_ten = 1)
    --    begin
    --        select isnull(sum(admissions), 0) as admissions,
    --            isnull(sum(census), 0) as census,
    --            isnull(sum(deliveries), 0) as deliveries,
    --            isnull(sum(er_admits), 0) as er_admits,
    --            isnull(sum(er_visits), 0) as er_visits,
    --            isnull(sum(op_visits), 0) as op_visits,
    --            sum(isnull(surgeries, 0)) as surgeries,
    --            isnull(sum(budgetAdmissions), 0) as budgetAdmissions,
    --            isnull(sum(priorYearAdmissions), 0) as priorYearAdmissions,
    --            isnull(sum(budgetSurgeries), 0) as budgetSurgeries,
    --            isnull(sum(priorYearSurgeries), 0) as priorYearSurgeries,
				--ISNULL(SUM(op_charges), 0) AS op_charges
    --        from @summary
    --        where top_ten = 1;
    --    end
    else if @top_ten = 1 OR @top_ten_list = 1
        BEGIN
            select *
            from @summary
            where top_ten = 1
				--AND top_ten_list = 1
            order by top_ten_sort_order
        end
    else if @new_operations = 1
        begin
            delete
            from @summary
            WHERE ISNULL(new_store, 0) = 0;
            
            select *
            from @summary
            order by facility_name;
        end;
    else
        begin
            select *
            from @summary
        end
END

