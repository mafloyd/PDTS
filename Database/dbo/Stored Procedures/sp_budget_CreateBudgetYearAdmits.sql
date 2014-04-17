CREATE procedure [dbo].[sp_budget_CreateBudgetYearAdmits]
    (
        @budgetYear int
    )
as
begin
    set nocount on

    declare @pdts_provider_id int
    declare @monthno int
    declare @avg_inpatient int
    declare @inpatient_total int
    declare @avg_outpatient int
    declare @outpatient_total int
    declare @3year_total int
    declare @avg_percent_of_total decimal (6, 2)
    declare @sum_admits int
    declare @projected_total int;
    declare @current_total int;
    declare @running_total int
    declare @tmp_total int;
    declare @diff int;

    declare cur cursor fast_forward read_only for
    select distinct a.pdts_provider_id
    from provider a
        join currentyear_admit b
            on a.pdts_provider_id = b.pdts_provider_id
                and b.year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2, @budgetYear - 1)
    order by a.pdts_provider_id;
        
    open cur

    fetch next from cur
    into @pdts_provider_id

    while @@fetch_status = 0
        begin
            select @3year_total = 0;
            select @projected_total = 0;
            select @running_total = 0;
            
            select @3year_total = isnull(sum(admits), 0)
            from currentyear_admit
            where pdts_provider_id = @pdts_provider_id
                and year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2);
                
            select @projected_total = isnull(period9_admits + period10_admits + period11_admits + period12_admits, 0)
            from ProjectedAdmits
            where pdts_provider_id = @pdts_provider_id
                and year = @budgetYear - 1
            
            select @current_total = isnull(sum(admits), 0)
            from currentyear_admit
            where pdts_provider_id = @pdts_provider_id
                and year = @budgetYear - 1
            
            select @projected_total = isnull(@projected_total + @current_total, 0);
            
            select @monthno = 1
            
            while @monthno < 13
                begin
                    select @tmp_total = 0;
                    select @avg_percent_of_total = 0.00;
                    select @sum_admits = 0;
                           
                    select @sum_admits = isnull(sum(admits), 0)
                    from currentyear_admit
                    where pdts_provider_id = @pdts_provider_id
                        and year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2)
                        and monthno = @monthno
                        and admits > 0;
                                  
                    if @sum_admits > 0 and @3year_total > 0
                        begin
                            select @avg_percent_of_total = cast(@sum_admits as decimal(6, 2)) / cast(@3year_total as decimal(6, 2))
                        end
                    else
                        begin
                            select @avg_percent_of_total = 0.00;
                        end
                                                               
                    select @tmp_total = isnull(round(isnull(@projected_total, 0) * isnull(@avg_percent_of_total, 0), 0), 0);
                                
                    if @tmp_total is null
                        begin
                            select @tmp_total = 0
                        end
                        
                    select @running_total = @running_total + @tmp_total;
      
                    if @monthno = 12
                        begin
                            select @diff = @projected_total - @running_total;
                            
                            select @tmp_total = @tmp_total + @diff;
                        end
                                    
                    IF EXISTS
						(
							SELECT 1
							FROM dbo.BudgetYear_Admit WITH (NOLOCK)
							WHERE PDTS_PROVIDER_ID = @pdts_provider_id
								AND YEAR = @budgetYear
								AND MONTHNO = @monthno
						)
						BEGIN
							UPDATE dbo.BudgetYear_Admit
							SET admits = @tmp_total,
								UPDATE_DATE = GETDATE(),
								UPDATED_BY_USER_ID = 483
							WHERE PDTS_PROVIDER_ID = @pdts_provider_id
								AND year = @budgetYear
								AND MONTHNO = @monthno;
						END;
					ELSE
						begin
							insert into budgetyear_admit (pdts_provider_id, monthno, year, admits, created_by_user_id)
							values (@pdts_provider_id, @monthno, @budgetYear, @tmp_total, 483)
						END;
                                
                    IF EXISTS 
						(
							SELECT 1 FROM dbo.BudgetAdmitPercentage
							WHERE pdts_provider_id = @pdts_provider_id
								AND BUDGET_YEAR = @budgetYear
								AND MONTHNO = @monthno
						)
						BEGIN
							UPDATE dbo.BudgetAdmitPercentage
							SET AVERAGE_PERCENTAGE = @avg_percent_of_total
							WHERE PDTS_PROVIDER_ID = @pdts_provider_id
								AND BUDGET_YEAR = @budgetYear
								AND MONTHNO = @monthno;
						end
					ELSE
						begin
							insert into BudgetAdmitPercentage 
								(
									pdts_provider_id, 
									budget_year, 
									monthno, 
									average_percentage
								)
							values
								(
									@pdts_provider_id,
									@budgetYear,
									@monthno,
									@avg_percent_of_total
								)
						END;
                                    
                    select @monthno = @monthno + 1
                end
                            
            fetch next from cur
            into @pdts_provider_id
        end
        
    close cur
    deallocate cur
end

