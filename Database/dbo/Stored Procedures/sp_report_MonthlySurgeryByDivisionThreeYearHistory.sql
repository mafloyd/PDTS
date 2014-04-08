
CREATE procedure [dbo].[sp_report_MonthlySurgeryByDivisionThreeYearHistory]
    (
        @division_id varchar(5),
        @year INT,
		@monthno INT
    )
as
begin
    set nocount on
    
    declare @pdts_provider_id int
    declare @surgical_type_id int
    declare @inpatient int
    declare @outpatient int
    
	IF object_id('tempdb..#surg') IS NOT NULL
		BEGIN
			DROP TABLE #surg;      
		END;  

    CREATE TABLE #surg
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
            cy_ytd_inpatient INT DEFAULT 0,
            cy_ytd_outpatient INT DEFAULT 0,
            py_ytd_inpatient INT DEFAULT 0,
            py_ytd_outpatient INT DEFAULT 0,
			py1_ytd_inpatient INT DEFAULT 0,
			py1_ytd_outpatient INT DEFAULT 0,
			py2_ytd_inpatient INT DEFAULT 0,
			py2_ytd_outpatient INT DEFAULT 0,
			py3_ytd_inpatient INT DEFAULT 0,
			py3_ytd_outpatient INT DEFAULT 0,
            primary key (pdts_provider_id, surgical_type_id)
        )
        
	DECLARE @surg table
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
            cy_ytd_inpatient INT DEFAULT 0,
            cy_ytd_outpatient INT DEFAULT 0,
            py_ytd_inpatient INT DEFAULT 0,
            py_ytd_outpatient INT DEFAULT 0,
			py1_ytd_inpatient INT DEFAULT 0,
			py1_ytd_outpatient INT DEFAULT 0,
			py2_ytd_inpatient INT DEFAULT 0,
			py2_ytd_outpatient INT DEFAULT 0,
			py3_ytd_inpatient INT DEFAULT 0,
			py3_ytd_outpatient INT DEFAULT 0,
            primary key (pdts_provider_id, surgical_type_id)
        )

	-- year 1
    insert into #surg 
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
        cys.surgical_type_id,
        st.long_name
    from provider p WITH (NOLOCK)
        join currentyear_surgery cys WITH (NOLOCK)
            on p.pdts_provider_id = cys.pdts_provider_id
                and year = (@year - 3)
                and monthno <= @monthno
                
        join surgical_type st WITH (NOLOCK)
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s WITH (NOLOCK)
            on p.specialty_id = s.specialty_id
            
        join facility f WITH (NOLOCK)
            on p.coid = f.coid
    where f.division_id = @division_id

	-- year 2
	insert into #surg 
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
        cys.surgical_type_id,
        st.long_name
    from provider p WITH (NOLOCK)
        join currentyear_surgery cys WITH (NOLOCK)
            on p.pdts_provider_id = cys.pdts_provider_id
                and year = (@year - 2)
                and monthno <= @monthno
                
        join surgical_type st WITH (NOLOCK)
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s WITH (NOLOCK)
            on p.specialty_id = s.specialty_id
            
        join facility f WITH (NOLOCK)
            on p.coid = f.coid

		LEFT JOIN #surg surg
			ON cys.PDTS_PROVIDER_ID = surg.pdts_provider_id
				AND cys.SURGICAL_TYPE_ID = surg.surgical_type_id
    where f.division_id = @division_id
		AND surg.pdts_provider_id IS null
    
	-- year 1
	insert into #surg 
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
        cys.surgical_type_id,
        st.long_name
    from provider p WITH (NOLOCK)
        join currentyear_surgery cys WITH (NOLOCK)
            on p.pdts_provider_id = cys.pdts_provider_id
                and year = (@year - 1)
                and monthno <= @monthno
                
        join surgical_type st WITH (NOLOCK)
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s WITH (NOLOCK)
            on p.specialty_id = s.specialty_id
            
        join facility f WITH (NOLOCK)
            on p.coid = f.coid

		LEFT JOIN #surg surg
			ON cys.PDTS_PROVIDER_ID = surg.pdts_provider_id
				AND cys.SURGICAL_TYPE_ID = surg.surgical_type_id
    where f.division_id = @division_id
		AND surg.pdts_provider_id IS NULL
        
    -- year 1
	insert into #surg 
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
        cys.surgical_type_id,
        st.long_name
    from provider p WITH (NOLOCK)
        join currentyear_surgery cys WITH (NOLOCK)
            on p.pdts_provider_id = cys.pdts_provider_id
                and year = (@year - 1)
                and monthno <= @monthno
                
        join surgical_type st WITH (NOLOCK)
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s WITH (NOLOCK)
            on p.specialty_id = s.specialty_id
            
        join facility f WITH (NOLOCK)
            on p.coid = f.coid

		LEFT JOIN #surg surg
			ON cys.PDTS_PROVIDER_ID = surg.pdts_provider_id
				AND cys.SURGICAL_TYPE_ID = surg.surgical_type_id
    where f.division_id = @division_id
		AND surg.pdts_provider_id IS NULL
	
	-- year 0
	insert into #surg 
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
        cys.surgical_type_id,
        st.long_name
    from provider p WITH (NOLOCK)
        join currentyear_surgery cys WITH (NOLOCK)
            on p.pdts_provider_id = cys.pdts_provider_id
                and year = @year
                and monthno <= @monthno
                
        join surgical_type st WITH (NOLOCK)
            on cys.surgical_type_id = st.surgical_type_id
            
        left join specialty s WITH (NOLOCK)
            on p.specialty_id = s.specialty_id
            
        join facility f WITH (NOLOCK)
            on p.coid = f.coid

		LEFT JOIN #surg surg
			ON cys.PDTS_PROVIDER_ID = surg.pdts_provider_id
				AND cys.SURGICAL_TYPE_ID = surg.surgical_type_id
    where f.division_id = @division_id
		AND surg.pdts_provider_id IS NULL
	
	-- year 0	
	UPDATE s
	SET cy_ytd_inpatient = 
		(
			SELECT SUM(inpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE PDTS_PROVIDER_ID = s.pdts_provider_id
				AND SURGICAL_TYPE_ID = s.surgical_type_id
				AND year = @year
				AND MONTHNO <= @monthno
		)
	FROM #surg s
	
	UPDATE s
	SET cy_ytd_outpatient =
		(
			SELECT SUM(outpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE pdts_provider_id = s.pdts_provider_id
				AND surgical_type_id = s.surgical_type_id
				AND year = @year
				AND monthno <= @monthno
		)
	FROM #surg s

	-- year 1
	UPDATE s
	SET py_ytd_inpatient = 
		(
			SELECT SUM(inpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE PDTS_PROVIDER_ID = s.pdts_provider_id
				AND SURGICAL_TYPE_ID = s.surgical_type_id
				AND year = (@year - 1)
				AND MONTHNO <= @monthno
		)
	FROM #surg s
	
	UPDATE s
	SET py_ytd_outpatient =
		(
			SELECT SUM(outpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE pdts_provider_id = s.pdts_provider_id
				AND surgical_type_id = s.surgical_type_id
				AND year = (@year - 1)
				AND monthno <= @monthno
		)
	FROM #surg s

	UPDATE s
	SET py1_ytd_inpatient = 
		(
			SELECT SUM(inpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE PDTS_PROVIDER_ID = s.pdts_provider_id
				AND SURGICAL_TYPE_ID = s.surgical_type_id
				AND year = (@year - 1)
		)
	FROM #surg s
	
	UPDATE s
	SET py1_ytd_outpatient =
		(
			SELECT SUM(outpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE pdts_provider_id = s.pdts_provider_id
				AND surgical_type_id = s.surgical_type_id
				AND year = (@year - 1)
		)
	FROM #surg s

	-- year 2
	UPDATE s
	SET py2_ytd_inpatient = 
		(
			SELECT SUM(inpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE PDTS_PROVIDER_ID = s.pdts_provider_id
				AND SURGICAL_TYPE_ID = s.surgical_type_id
				AND year = (@year - 2)
		)
	FROM #surg s
	
	UPDATE s
	SET py2_ytd_outpatient =
		(
			SELECT SUM(outpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE pdts_provider_id = s.pdts_provider_id
				AND surgical_type_id = s.surgical_type_id
				AND year = (@year - 2)
		)
	FROM #surg s

	-- year 3
	UPDATE s
	SET py3_ytd_inpatient = 
		(
			SELECT SUM(inpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE PDTS_PROVIDER_ID = s.pdts_provider_id
				AND SURGICAL_TYPE_ID = s.surgical_type_id
				AND year = (@year - 3)
		)
	FROM #surg s
	
	UPDATE s
	SET py3_ytd_outpatient =
		(
			SELECT SUM(outpatient)
			FROM CurrentYear_Surgery cys WITH (NOLOCK)
			WHERE pdts_provider_id = s.pdts_provider_id
				AND surgical_type_id = s.surgical_type_id
				AND year = (@year - 3)
		)
	FROM #surg s

	INSERT INTO @surg
	SELECT *
	FROM #surg

    select 
		facility,
        pdts_provider_id,
        provider_id,
        first_name,
        middle_name,
        last_name,
        specialty,
        note,
        surgical_type_id,
        surgical_type,
        ISNULL(cy_ytd_inpatient, 0) AS cy_ytd_inpatient,
        ISNULL(cy_ytd_outpatient, 0) AS cy_ytd_outpatient,
        ISNULL(py_ytd_inpatient, 0) AS py_ytd_inpatient,
        ISNULL(py_ytd_outpatient, 0) AS py_ytd_outpatient,
		ISNULL(py1_ytd_inpatient, 0) AS py1_ytd_inpatient,
		ISNULL(py1_ytd_outpatient, 0) AS py1_ytd_outpatient,
		ISNULL(py2_ytd_inpatient, 0) AS py2_ytd_inpatient,
		ISNULL(py2_ytd_outpatient, 0) AS py2_ytd_outpatient,
		ISNULL(py3_ytd_inpatient, 0) AS py3_ytd_inpatient,
		ISNULL(py3_ytd_outpatient, 0) AS py3_ytd_outpatient
    from @surg
	ORDER BY facility, surgical_type, specialty, last_name, first_name, middle_name
end

