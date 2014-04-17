CREATE procedure [dbo].[sp_budget_CreateBudgetYearSurgeries]
    (
        @budgetYear int
    )
as
begin
    set nocount on
    
    DECLARE @pdts_provider_id int
    declare @surgical_type_id int
    declare @monthno int
    declare @avg_inpatient int
    declare @inpatient_total int
    declare @avg_outpatient int
    declare @outpatient_total int
    declare @3year_inpatient_total int
    declare @3year_outpatient_total int
    declare @avg_inpatient_percent_of_total decimal (6, 2)
    declare @avg_outpatient_percent_of_total decimal (6, 2)
    declare @sum_inpatient int
    declare @sum_outpatient int
    declare @projected_inpatient_total int;
    declare @projected_outpatient_total int;
    declare @current_inpatient_total int;
    declare @current_outpatient_total int;
    declare @running_in_total int
    declare @running_out_total int
    declare @tmp_in int;
    declare @tmp_out int;
    declare @diff int;

    select @surgical_type_id = 1
    
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR 		
	SELECT DISTINCT pdts_provider_id
	FROM dbo.CurrentYear_Surgery
	WHERE year IN (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2, @budgetYear - 1);
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @pdts_provider_id;
	
	WHILE @@fetch_status = 0
		begin
			while @surgical_type_id < 6
				begin
					select @3year_inpatient_total = 0;
					select @3year_outpatient_total = 0;
					select @projected_inpatient_total = 0;
					select @projected_outpatient_total = 0;
					select @current_inpatient_total = 0;
					select @current_outpatient_total = 0;
					select @running_in_total = 0;
					select @running_out_total = 0;
		            
					select @3year_inpatient_total = isnull(sum(inpatient), 0),
						@3year_outpatient_total = isnull(sum(outpatient), 0)
					from currentyear_surgery with (nolock)
					where pdts_provider_id = @pdts_provider_id
						and surgical_type_id = @surgical_type_id
						and year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2)
		                
					select @projected_inpatient_total = isnull(period09_inpatient_surgeries + period10_inpatient_surgeries + period11_inpatient_surgeries + period12_inpatient_surgeries, 0),
						@projected_outpatient_total = isnull(period09_outpatient_surgeries + period10_outpatient_surgeries + period11_outpatient_surgeries +period12_outpatient_surgeries, 0)
					from ProjectedSurgeries with (nolock)
					where pdts_provider_id = @pdts_provider_id
						and year = @budgetYear - 1
						and surgical_type_id = @surgical_type_id
		                
					select @current_inpatient_total = isnull(sum(inpatient), 0),
						@current_outpatient_total = isnull(sum(outpatient), 0)
					from currentyear_surgery with (nolock)
					where pdts_provider_id = @pdts_provider_id
						and surgical_type_id = @surgical_type_id
						and year = @budgetYear - 1
		                
					select @projected_inpatient_total = isnull(@projected_inpatient_total + @current_inpatient_total, 0),
						@projected_outpatient_total = isnull(@projected_outpatient_total + @current_outpatient_total, 0)
		                                   
		            IF NOT EXISTS
						(
							SELECT 1
							FROM dbo.BudgetThreeYearTotal WITH (NOLOCK)
							WHERE PDTS_PROVIDER_ID = @pdts_provider_id
								AND BUDGET_YEAR = @budgetYear
								AND SURGICAL_TYPE_ID = @surgical_type_id
						)
						begin        
							insert into BudgetThreeYearTotal
								(
									pdts_provider_id,
									budget_year,
									surgical_type_id,
									inpatient_total,
									outpatient_total
								)
							values
								(
									@pdts_provider_id,
									@budgetYear,
									@surgical_type_id,
									@3year_inpatient_total,
									@3year_outpatient_total
								)
						END;
					ELSE
						begin
							UPDATE dbo.BudgetThreeYearTotal
							SET INPATIENT_TOTAL = @3year_inpatient_total,
								OUTPATIENT_TOTAL = @3year_outpatient_total
							WHERE PDTS_PROVIDER_ID = @pdts_provider_id
								AND budget_year = @budgetYear
								AND SURGICAL_TYPE_ID = @surgical_type_id;
						END;
		                
					select @monthno = 1
						while @monthno < 13
							begin
								select @sum_inpatient = 0;
								select @sum_outpatient = 0;
								select @tmp_in = 0;
								select @tmp_out = 0;
								select @avg_inpatient_percent_of_total = 0.0;
								select @avg_outpatient_percent_of_total = 0.0;
		                        
								select @sum_inpatient = isnull(sum(inpatient), 0)
								from currentyear_surgery with (nolock)
								where pdts_provider_id = @pdts_provider_id
									and surgical_type_id = @surgical_type_id
									and year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2)
									and monthno = @monthno
									and inpatient > 0;
		                        
								select @sum_outpatient = isnull(sum(outpatient), 0)
								from currentyear_surgery with (nolock)
								where pdts_provider_id = @pdts_provider_id
									and surgical_type_id = @surgical_type_id
									and year in (@budgetYear - 4, @budgetYear - 3, @budgetYear - 2)
									and monthno = @monthno
									and outpatient > 0;
		                                
								if @sum_inpatient > 0 and @3year_inpatient_total > 0
									begin
										select @avg_inpatient_percent_of_total = cast(@sum_inpatient as decimal(6, 2)) / cast(@3year_inpatient_total as decimal(6, 2))
									end
								else
									begin
										select @avg_inpatient_percent_of_total = 0.00;
									end
		                            
								if @sum_outpatient > 0 and @3year_outpatient_total > 0
									begin
										select @avg_outpatient_percent_of_total = cast(@sum_outpatient as decimal(6, 2)) / cast(@3year_outpatient_total as decimal(6, 2))
									end
								else
									begin
										select @avg_outpatient_percent_of_total = 0.00;
									end
		                                            
								select @tmp_in = isnull(round(isnull(@projected_inpatient_total, 0) * isnull(@avg_inpatient_percent_of_total, 0), 0), 0);
								select @tmp_out = isnull(round(isnull(@projected_outpatient_total, 0) * isnull(@avg_outpatient_percent_of_total, 0), 0), 0);
		                        
								if @tmp_in is null
									begin
										select @tmp_in = 0;
									end
		                            
								if @tmp_out is null
									begin
										select @tmp_out = 0;
									end
		                            
								 select @running_in_total = @running_in_total + @tmp_in;
								 select @running_out_total = @running_out_total + @tmp_out;
		                         
								 if @monthno = 12
									begin
										select @diff = @projected_inpatient_total - @running_in_total;
		                                
										select @tmp_in = @tmp_in + @diff;
		                                     
										select @diff = @projected_outpatient_total - @running_out_total;
		                                
										select @tmp_out = @tmp_out + @diff;
									end
		                            
		                        IF NOT EXISTS
									(
										SELECT 1
										FROM BudgetYear_Surgery WITH (NOLOCK)
										WHERE  PDTS_PROVIDER_ID = @pdts_provider_id
											AND SURGICAL_TYPE_ID = @surgical_type_id
											AND year = @budgetYear
											AND MONTHNO = @monthno
									)
									begin
										insert into budgetyear_surgery (pdts_provider_id, surgical_type_id, monthno, year, inpatient, outpatient, created_by_user_id)
										values (@pdts_provider_id, @surgical_type_id, @monthno, @budgetYear, @tmp_in, @tmp_out, 483)
									END
								ELSE
									BEGIN
										UPDATE dbo.BudgetYear_Surgery
										SET inpatient = @tmp_in,
											outpatient = @tmp_out,
											UPDATE_DATE = GETDATE(),
											UPDATED_BY_USER_ID = 483
										WHERE PDTS_PROVIDER_ID = @pdts_provider_id
											AND SURGICAL_TYPE_ID = @surgical_type_id
											AND year = @budgetYear
											AND MONTHNO = @monthno;
									END;
		                        
		                        IF NOT EXISTS
									(
										SELECT 1
										FROM BudgetSurgeryPercentage WITH (NOLOCK)
										WHERE PDTS_PROVIDER_ID = @pdts_provider_id
											AND BUDGET_YEAR = @budgetYear
											AND SURGICAL_TYPE_ID = @surgical_type_id
											AND MONTHNO = @monthno
									)
									begin
										insert into BudgetSurgeryPercentage 
											(
												pdts_provider_id, 
												budget_year, 
												surgical_type_id, 
												monthno, 
												average_inpatient_percent_of_total, 
												average_outpatient_percent_of_total
											)
										values
											(
												@pdts_provider_id,
												@budgetYear,
												@surgical_type_id,
												@monthno,
												@avg_inpatient_percent_of_total,
												@avg_outpatient_percent_of_total
											)
									END
								ELSE
									BEGIN
										UPDATE dbo.BudgetSurgeryPercentage
										SET AVERAGE_INPATIENT_PERCENT_OF_TOTAL = @avg_inpatient_percent_of_total,
											AVERAGE_OUTPATIENT_PERCENT_OF_TOTAL = @avg_outpatient_percent_of_total
										WHERE PDTS_PROVIDER_ID = @pdts_provider_id
											AND BUDGET_YEAR = @budgetYear
											AND SURGICAL_TYPE_ID = @surgical_type_id
											AND MONTHNO = @monthno;
									END;
		                            
								select @monthno = @monthno + 1
							end
		            
					select @surgical_type_id = @surgical_type_id + 1
				END
				
				SELECT @surgical_type_id = 1;
				
				FETCH NEXT FROM cur 
				INTO @pdts_provider_id
			END;
end

