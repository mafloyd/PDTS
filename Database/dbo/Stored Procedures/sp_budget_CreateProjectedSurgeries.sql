CREATE procedure [dbo].[sp_budget_CreateProjectedSurgeries]
    (
        @currentYear int
    )
as
begin
    set nocount on

    declare @pdts_provider_id int
    declare @avg_p09_inpatient int
    declare @avg_p09_outpatient int
    declare @avg_p10_inpatient int
    declare @avg_p10_outpatient int
    declare @avg_p11_inpatient int
    declare @avg_p11_outpatient int
    declare @avg_p12_inpatient int
    declare @avg_p12_outpatient int
    declare @surgical_type_id int

    declare cur cursor fast_forward read_only for
    select distinct a.pdts_provider_id
    from provider a
        join currentyear_surgery b
            on a.pdts_provider_id = b.pdts_provider_id
                and b.year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)

    open cur

    fetch next from cur
    into @pdts_provider_id

    while @@fetch_status = 0
        begin
            select @surgical_type_id = 1
            
            while @surgical_type_id < 6
                begin
                    -- does this provider have surgery type 1 numbers for past two years
                    select @avg_p09_inpatient = isnull(avg(inpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 9
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and inpatient > 0
                        
                    select @avg_p09_outpatient = isnull(avg(outpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 9
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and outpatient > 0
                        
                    select @avg_p10_inpatient = isnull(avg(inpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 10
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and inpatient > 0
                        
                    select @avg_p10_outpatient = isnull(avg(outpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 10
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and outpatient > 0
                        
                    select @avg_p11_inpatient = isnull(avg(inpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 11
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and inpatient > 0
                        
                    select @avg_p11_outpatient = isnull(avg(outpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 11
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and outpatient > 0
                        
                    select @avg_p12_inpatient = isnull(avg(inpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 12
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and inpatient > 0
                        
                    select @avg_p12_outpatient = isnull(avg(outpatient), 0)
                    from currentyear_surgery
                    where pdts_provider_id = @pdts_provider_id
                        and monthno = 12
                        and year in (@currentYear - 3, @currentYear - 2, @currentYear - 1)
                        and surgical_type_id = @surgical_type_id
                        and outpatient > 0
                        
                    IF EXISTS (SELECT 1 FROM ProjectedSurgeries WITH (NOLOCK) WHERE pdts_provider_id = @pdts_provider_id AND year = @currentYear AND SURGICAL_TYPE_ID = @surgical_type_id)
						BEGIN
							UPDATE dbo.ProjectedSurgeries
							SET PERIOD09_INPATIENT_SURGERIES = @avg_p09_inpatient,
								PERIOD10_INPATIENT_SURGERIES = @avg_p10_inpatient,
								PERIOD11_INPATIENT_SURGERIES = @avg_p11_inpatient,
								PERIOD12_INPATIENT_SURGERIES = @avg_p12_inpatient,
								PERIOD09_OUTPATIENT_SURGERIES = @avg_p09_outpatient,
								PERIOD10_OUTPATIENT_SURGERIES = @avg_p10_outpatient,
								PERIOD11_OUTPATIENT_SURGERIES = @avg_p11_outpatient,
								PERIOD12_outpatient_surgeries = @avg_p12_outpatient
							WHERE pdts_provider_id = @pdts_provider_id
								AND YEAR = @currentyear
								AND surgical_type_id = @surgical_type_id;
						END;
					ELSE
						begin
							insert into ProjectedSurgeries 
								(
									pdts_provider_id, 
									year, 
									surgical_type_id, 
									period09_inpatient_surgeries, 
									period10_inpatient_surgeries, 
									period11_inpatient_surgeries, 
									period12_inpatient_surgeries, 
									period09_outpatient_surgeries,
									period10_outpatient_surgeries,
									period11_outpatient_surgeries,
									period12_outpatient_surgeries,
									created_by_user_id
								)
							values 
								(
									@pdts_provider_id, 
									@currentYear, 
									@surgical_type_id, 
									@avg_p09_inpatient, 
									@avg_p10_inpatient, 
									@avg_p11_inpatient, 
									@avg_p12_inpatient, 
									@avg_p09_outpatient,
									@avg_p10_outpatient,
									@avg_p11_outpatient,
									@avg_p12_outpatient,
									483
								 );
						END;
                    
                    select @surgical_type_id = @surgical_type_id + 1
                end
            
            fetch next from cur
            into @pdts_provider_id
        end
        
    close cur
    deallocate cur
end
