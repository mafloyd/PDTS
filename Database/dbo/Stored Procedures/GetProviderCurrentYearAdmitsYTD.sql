


-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/20/2011
-- Description:	Get provider admits by YTD
-- =============================================
CREATE PROCEDURE [dbo].[GetProviderCurrentYearAdmitsYTD] 
    (
        @year int,
        @month int,
		@getNotes bit = 0
    )
AS
BEGIN
    declare @pdts_provider_id int;
    declare @note varchar(1000);
    
    declare @admits table 
        (
            pdts_provider_id int,
            coid varchar(5),
            name varchar(50),
            provider_id int,
            last_name varchar(50),
            first_name varchar(50),
            middle_name varchar(50),
            long_name varchar(50),
            admits int,
            left_date datetime,
            note varchar(1000),
            primary key (pdts_provider_id)
        );
        
    insert into @admits (pdts_provider_id, coid, name, provider_id, last_name, first_name, middle_name, long_name, admits, left_date)
	select 
	    p.pdts_provider_id,
        p.coid, 
        c.name, 
        p.provider_id, 
        p.last_name, 
        p.first_name, 
        p.middle_name, 
        s.long_name, 
        sum(b.admits) as admits,
        case p.left_date when '9999-09-09 00:00:00.000' then ''
            else p.left_date end as left_date
    from provider p with (nolock)
        join currentyear_admit b with (nolock)
            on p.pdts_provider_id = b.pdts_provider_id
                and b.year = @year
                and b.monthno <= @month
                        
        join facility c
            on p.coid = c.coid
                    
        left join specialty s
            on p.specialty_id = s.specialty_id
	group by p.pdts_provider_id, p.coid, c.name, p.provider_id, p.last_name, p.first_name, p.middle_name, s.long_Name, left_date


	-- now get the current note
	if @getNotes = 1 
		begin
			declare cur cursor fast_forward read_only for
			select pdts_provider_id 
			from @admits

			open cur
	
			fetch next from cur
			into @pdts_provider_id

			while @@fetch_status = 0
				begin
					select @note = (select top 1 note
									from note
									where pdts_provider_id = @pdts_provider_id
										and note_type_id = 1
										and datepart(yyyy, create_date) = @year
										and datepart(mm, create_date) <= @month
									order by create_date desc)

					update @admits
					set note = @note
					where pdts_provider_id = @pdts_provider_id

					fetch next from cur
					into @pdts_provider_id
				end

			close cur
			deallocate cur
		end

    select *
    from @admits
    order by name, last_name, first_name
END



