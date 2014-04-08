CREATE procedure [dbo].[sp_report_BudgetSurgery]
    (
        @coid varchar(5),
        @year int
    )
as    
begin
    set nocount on
    
    declare @pdts_provider_id int
    declare @inpatient int
    declare @outpatient int
    declare @surgical_type_id int

    declare @surg table
        (
            pdts_provider_id int,
            provider_id int,
            first_name varchar(50),
            middle_name varchar(50),
            last_name varchar(50),
            dob datetime,
            facility_name varchar(50),
            specialty varchar(50),
            status varchar(50),
            physician_group varchar(50),
            surgical_type_id int,
            surgical_type varchar(100),
            year1Inpatient int default 0,
            year1Outpatient int default 0,
            projectedInpatient int default 0,
            projectedOutpatient int default 0,
            currentInpatient int default 0,
            currentOutpatient int default 0,
            budgetInpatient int default 0,
            budgetOutpatient int default 0,
            note varchar(1000),
            provider_position_status_id int,
            start_date datetime,
            left_date datetime,
            primary key (pdts_provider_id, surgical_type_id)
        )
        
    insert into @surg
        (
            pdts_provider_id,
            provider_id,
            first_name,
            middle_name,
            last_name,
            dob,
            facility_name,
            specialty,
            status,
            provider_position_status_id,
            physician_group,
            surgical_type_id,
            surgical_type,
            start_date,
            left_date,
            note
        )
    select distinct
        p.pdts_provider_id,
        p.PROVIDER_ID, 
        p.FIRST_NAME, 
        p.MIDDLE_NAME, 
        p.LAST_NAME, 
        p.DOB, 
        f.NAME AS facility_name, 
        s.LONG_NAME AS specialty,
        b.name as status,
        b.provider_position_status_id,
        isnull(p.physician_group, 'None') as physician_group,
        cys.surgical_type_id,
        st.long_name,
        p.start_date,
        p.left_date,
        (select top 1 note from note where pdts_provider_id = p.pdts_provider_id and note_type_id = 3 and budget_year = @year order by create_date desc) as note
    FROM Provider p 
        JOIN Facility f 
            ON p.COID = f.COID 
            
        LEFT OUTER JOIN Specialty s 
            ON p.SPECIALTY_ID = s.SPECIALTY_ID
        
        left outer join ProviderPositionStatus b
	        on p.provider_position_status_id = b.provider_position_status_id
    	    
	    join currentyear_surgery cys
	        on p.pdts_provider_id = cys.pdts_provider_id
	        
	    join surgical_type st
	        on cys.surgical_type_id = st.surgical_type_id
    WHERE  (p.COID = @coid) and s.short_name is not null
    ORDER BY p.provider_id

    declare cur cursor fast_forward read_only for
    select pdts_provider_id, surgical_type_id 
    from @surg

    open cur

    fetch next from cur
    into @pdts_provider_id, @surgical_type_id

    while @@fetch_status = 0
        begin
            select @inpatient = 0
            select @outpatient = 0
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year - 2
            
            update @surg
            set year1Inpatient = @inpatient,
                year1Outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
             
            select @inpatient = 0
            select @outpatient = 0
            
            select @inpatient = isnull(period09_inpatient_surgeries, 0) + isnull(period10_inpatient_surgeries, 0) + isnull(period11_inpatient_surgeries, 0) + isnull(period12_inpatient_surgeries, 0),
                @outpatient = isnull(period09_outpatient_surgeries, 0) + isnull(period10_outpatient_surgeries, 0) + isnull(period11_outpatient_surgeries, 0 ) + isnull(period12_outpatient_surgeries, 0)
            from ProjectedSurgeries
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            update @surg
            set projectedInpatient = @inpatient,
                projectedOutpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            select @inpatient = 0
            select @outpatient = 0
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year - 1
                and monthno < 9
                 
            update @surg
            set currentInpatient = @inpatient,
                currentOutpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            select @inpatient = 0
            select @outpatient = 0
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from budgetyear_surgery
                where pdts_provider_id = @pdts_provider_id
                    and surgical_type_id = @surgical_type_id
                    and year = @year
                    
            update @surg
            set budgetInpatient = @inpatient,
                budgetOutpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            fetch next from cur
            into @pdts_provider_id, @surgical_type_id
        end
        
    close cur
    deallocate cur
    
    select *
    from @surg
    order by surgical_type, last_name, first_name, middle_name
end

