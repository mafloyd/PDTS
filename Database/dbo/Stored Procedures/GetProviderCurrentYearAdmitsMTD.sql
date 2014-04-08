

-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/20/2011
-- Description:	Get provider admits by MTD
-- =============================================
CREATE PROCEDURE [dbo].[GetProviderCurrentYearAdmitsMTD] 
    (
        @year int,
        @month int
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
        
    insert into @admits (pdts_provider_id, coid, name, provider_id, last_name, first_name, middle_name, long_name, admits, left_date, note)
	select 
	    p.pdts_provider_id,
        p.coid, 
        c.name, 
        p.provider_id, 
        p.last_name, 
        p.first_name, 
        p.middle_name, 
        s.long_name, 
        b.admits,
        case p.left_date when '9999-09-09 00:00:00.000' then ''
            else p.left_date end as left_date,
		n.note
    from provider p with (nolock)
        join currentyear_admit b with (nolock)
            on p.pdts_provider_id = b.pdts_provider_id
                and b.year = @year
                and b.monthno = @month
                        
        join facility c
            on p.coid = c.coid
                    
        left join specialty s
            on p.specialty_id = s.specialty_id

		left join currentyear_admit_note_xref x
			on b.currentyear_admit_id = x.currentyear_admit_id

		left join note n
			on x.note_id = n.note_id

    select *
    from @admits
    order by name, last_name, first_name
END


