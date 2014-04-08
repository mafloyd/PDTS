
CREATE PROCEDURE [dbo].[sp_utility_CreateStubBudgetEntries]
	(
	    @pdts_provider_id int,
	    @year int,
	    @created_by_user_id int
	)
AS
BEGIN
	SET NOCOUNT ON;
    
    declare @month int
    declare @surgical_type_id int
    
    select @month = 1
    
    while @month < 13
        begin            
            if not exists 
                (
                    select 1
                    from BudgetYear_Admit with (nolock)
                    where pdts_provider_id = @pdts_provider_id
                        and year = @year
                        and monthno = @month
                )
                begin
                    insert into BudgetYear_Admit (pdts_provider_id, year, monthno, admits, created_by_user_id)
                    values (@pdts_provider_id, @year, @month, 0, @created_by_user_id)
                end
                
            if not exists
                (
                    select 1
                    from CurrentYear_Admit with (nolock)
                    where pdts_provider_id = @pdts_provider_id
                        and year = @year - 1
                        and monthno = @month
                )
                begin
                    insert into CurrentYear_Admit (pdts_provider_id, year, monthno, admits, created_by_user_id)
                    values (@pdts_provider_id, @year - 1, @month, 0, @created_by_user_id)
                end
                
                select @surgical_type_id = 1
                
                while @surgical_type_id < 6
                    begin
                        if not exists 
                            (
                                select 1
                                from BudgetYear_Surgery with (nolock)
                                where pdts_provider_id = @pdts_provider_id
                                    and surgical_type_id = @surgical_type_id
                                    and year = @year
                                    and monthno = @month
                            )
                            begin
                                insert into BudgetYear_Surgery (pdts_provider_id, surgical_type_id, year, monthno, inpatient, outpatient, created_by_user_id)
                                values (@pdts_provider_id, @surgical_type_id, @year, @month, 0, 0, @created_by_user_id)
                            end
                            
                        if not exists 
                            (
                                select 1
                                from CurrentYear_Surgery with (nolock)
                                where pdts_provider_id = @pdts_provider_id
                                    and surgical_type_id = @surgical_type_id
                                    and year = @year - 1
                                    and monthno = @month
                            )
                            begin
                                insert into CurrentYear_Surgery (pdts_provider_id, surgical_type_id, year, monthno, inpatient, outpatient, created_by_user_id)
                                values (@pdts_provider_id, @surgical_type_id, @year - 1, @month, 0, 0, @created_by_user_id)
                            end
                            
                        select @surgical_type_id = @surgical_type_id + 1
                    end
                    
            select @month = @month + 1;
        end
END

