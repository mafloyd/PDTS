CREATE procedure [dbo].[sp_budget_CreateProjectedAdmits]
    (
        @currentYear int
    )
as
begin
    set nocount on
	
	DECLARE @pdts_provider_id int
    declare @avg_p09 int
    declare @avg_p10 int
    declare @avg_p11 int
    declare @avg_p12 int

    DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
    SELECT DISTINCT pdts_provider_id
    FROM dbo.CurrentYear_Admit
    WHERE year IN (@currentYear - 3, @currentYear - 2, @currentYear - 1);
    
    OPEN cur
    
    FETCH NEXT FROM cur INTO
    @pdts_provider_id
                    
	WHILE @@fetch_status = 0
		begin
			select @avg_p09 = isnull(avg(admits), 0)
			from currentyear_admit
			where pdts_provider_id = @pdts_provider_id
				and monthno = 9
				and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
		                 
			select @avg_p10 = isnull(avg(admits), 0)
			from currentyear_admit
			where pdts_provider_id = @pdts_provider_id
				and monthno = 10
				and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
		        
			select @avg_p11 = isnull(avg(admits), 0)
			from currentyear_admit
			where pdts_provider_id = @pdts_provider_id
				and monthno = 1
				and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
		            
			select @avg_p12 = isnull(avg(admits), 0)
			from currentyear_admit
			where pdts_provider_id = @pdts_provider_id
				and monthno = 12
				and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
		    
		    IF EXISTS (SELECT 1 FROM ProjectedAdmits WHERE pdts_provider_id = @pdts_provider_id AND year = @currentYear)
				BEGIN
					UPDATE dbo.ProjectedAdmits
					SET PERIOD9_ADMITS = @avg_p09,
						PERIOD10_ADMITS = @avg_p10,
						PERIOD11_ADMITS = @avg_p11,
						PERIOD12_ADMITS = @avg_p12,
						update_date = GETDATE(),
						UPDATED_BY_USER_ID = 483
					WHERE PDTS_PROVIDER_ID = @pdts_provider_id
						AND year = @currentYear;
				END;
			ELSE
				begin
					insert into ProjectedAdmits
						(
							pdts_provider_id, 
							year, 
							period9_admits,
							period10_admits, 
							period11_admits, 
							period12_admits, 
							created_by_user_id
						)
					values 
						(
							@pdts_provider_id, 
							@currentYear,
							@avg_p09, 
							@avg_p10, 
							@avg_p11, 
							@avg_p12, 
							483
						 )
				END;
				
			FETCH NEXT FROM cur
			INTO @pdts_provider_id;
		END;
end

