
CREATE procedure [dbo].[sp_report_MonthlySurgeryQTD]
    (
        @coid varchar(5),
        @year int,
        @quarter int
    )
as
begin
    set nocount on
    
    declare @pdts_provider_id int
    declare @surgical_type_id int
    declare @inpatient int
    declare @outpatient INT
	DECLARE @begin_month int
	DECLARE @end_month int
    
	IF @quarter = 1
		BEGIN
			SELECT @begin_month = 1;
			SELECT @end_month = 3;      
		END;
	ELSE IF @quarter = 2
		BEGIN
			SELECT @begin_month = 4;
			SELECT @end_month = 6;      
		END;      
	ELSE IF @quarter = 3
		BEGIN
			SELECT @begin_month = 7;
			SELECT @end_month = 9;      
		END;      
	ELSE IF @quarter = 4
		BEGIN
			SELECT @begin_month = 10;
			SELECT @end_month = 12;      
		END;      

    declare @surg table
        (
            facility varchar(100),
            pdts_provider_id int,
            provider_id int,
            first_name varchar(50),
            middle_name varchar(50),
            last_name varchar(50),
            specialty varchar(100),
            note varchar(1000),
            surgical_type_id int,
            surgical_type varchar(50),
            cy_mtd_inpatient int,
            cy_mtd_outpatient int,
            cy_qtd_inpatient int,
            cy_qtd_outpatient int,
            py_mtd_inpatient int,
            py_mtd_outpatient int,
            py_qtd_inpatient int,
            py_qtd_outpatient int,
            cy_mtd_budget_inpatient int,
            cy_mtd_budget_outpatient int,
            cy_qtd_budget_inpatient int,
            cy_qtd_budget_outpatient int,
            primary key (pdts_provider_id, surgical_type_id)
        )
        
    insert into @surg 
        (
            facility,
            pdts_provider_id,
            provider_id,
            first_name,
            middle_name,
            last_name,
            specialty,
            surgical_type_id,
            surgical_type,
            note
        )
    select distinct 
        f.name as facility,
        p.pdts_provider_id,
        p.provider_id,
        p.first_name,
        p.middle_name,
        p.last_name,
        s.long_name as specialty,
        cys.surgical_type_id,
        st.long_name,
        (
            select TOP 1 n.note 
            from provider prov 
                left join currentyear_surgery cys
                    on prov.pdts_provider_id = cys.pdts_provider_id
                        and cys.year = @year
                        and cys.monthno between @begin_month AND @end_month
                        
                left join currentyear_surgery_note_xref xref
                    on cys.currentyear_surgery_id = xref.currentyear_surgery_id
                    
                left join note n
                    on xref.note_id = n.note_id 
            where prov.pdts_provider_id = p.pdts_provider_id
			ORDER BY n.create_date DESC
        ) as note
    from provider p
        join currentyear_surgery cys
            on p.pdts_provider_id = cys.pdts_provider_id
                and year >= @year - 1
                and monthno BETWEEN @begin_month AND @end_month
                
        join surgical_type st
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s
            on p.specialty_id = s.specialty_id
            
        join facility f
            on p.coid = f.coid
    where p.coid = @coid
    
    insert into @surg 
        (
            facility,
            pdts_provider_id,
            provider_id,
            first_name,
            middle_name,
            last_name,
            specialty,
            surgical_type_id,
            surgical_type
        )
    select distinct 
        f.name as facility,
        p.pdts_provider_id,
        p.provider_id,
        p.first_name,
        p.middle_name,
        p.last_name,
        s.long_name as specialty,
        bys.surgical_type_id,
        st.long_name
    from provider p
        join budgetyear_surgery bys
            on p.pdts_provider_id = bys.pdts_provider_id
                and year >= @year - 1
                and monthno BETWEEN @begin_month AND @end_month
                and (inpatient > 0 or outpatient > 0)
                
        join surgical_type st
            on bys.surgical_type_id = st.surgical_type_id
            
        left join specialty s
            on p.specialty_id = s.specialty_id
            
        join facility f
            on p.coid = f.coid
        
        left join @surg surg
            on p.pdts_provider_id =  surg.pdts_provider_id
                and bys.surgical_type_id = surg.surgical_type_id
    where p.coid = @coid
        and surg.pdts_provider_id is null
        and surg.surgical_type_id is null

    declare cur cursor fast_forward read_only for
    select pdts_provider_id, surgical_type_id
    from @surg
    
    open cur
    
    fetch next from cur
    into @pdts_provider_id, @surgical_type_id
    
    while @@fetch_status = 0
        begin
            -- current year
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set cy_mtd_inpatient = @inpatient,
                cy_mtd_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set cy_qtd_inpatient = @inpatient,
                cy_qtd_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            -- prior year
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year - 1
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set py_mtd_inpatient = @inpatient,
                py_mtd_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from currentyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year - 1
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set py_qtd_inpatient = @inpatient,
                py_qtd_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            -- budget year
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from budgetyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set cy_mtd_budget_inpatient = @inpatient,
                cy_mtd_budget_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
            
            select @inpatient = isnull(sum(inpatient), 0),
                @outpatient = isnull(sum(outpatient), 0)
            from budgetyear_surgery 
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                and year = @year
                and monthno BETWEEN @begin_month AND @end_month
                
            update @surg
            set cy_qtd_budget_inpatient = @inpatient,
                cy_qtd_budget_outpatient = @outpatient
            where pdts_provider_id = @pdts_provider_id
                and surgical_type_id = @surgical_type_id
                
            fetch next from cur
            into @pdts_provider_id, @surgical_type_id
        end
        
    close cur
    deallocate cur
    
    select *
    from @surg
END;


