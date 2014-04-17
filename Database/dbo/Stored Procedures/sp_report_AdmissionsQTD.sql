
CREATE PROCEDURE [dbo].[sp_report_AdmissionsQTD] (@coid VARCHAR(5), @quarter INT, @year INT)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @beginMonth INT;
	DECLARE @endMonth INT;

	IF @quarter = 1
		BEGIN
			SELECT @beginMonth = 1;
			SELECT @endMonth = 3;      
		END;      

	IF @quarter = 2
		BEGIN
			SELECT @beginMonth = 4;
			SELECT @endMonth = 6;      
		END;      

	IF @quarter = 3
		BEGIN
			SELECT @beginMonth = 7;
			SELECT @endMonth = 9;      
		END;      

	IF @quarter = 4
		BEGIN
			SELECT @beginMonth = 10;
			SELECT @endMonth = 12;      
		END;
		      
    select
    f.name as facility,
    p.pdts_provider_id,
    p.provider_id,
    p.first_name,
    p.middle_name,
    p.last_name,
    s.long_name as specialty,
    (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year and monthno BETWEEN @beginMonth AND @endMonth) as mtd_cm_admits,
    (select isnull(sum(admits), 0) from budgetyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year and monthno BETWEEN @beginMonth AND @endMonth) as mtd_budget_cm_admits,
    (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = (@year - 1) and monthno BETWEEN @beginMonth AND @endMonth) as mtd_py_cm_admits,
    (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year and monthno <= @endMonth) as ytd_cm_admits,
    (select isnull(sum(admits), 0) from budgetyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year and monthno <= @endMonth) as ytd_budget_cm_admits,
    (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = (@year - 1) and monthno <= @endMonth) as ytd_py_cm_admits,
    (
        select n.note 
        from provider prov 
            left join currentyear_admit cya
                on prov.pdts_provider_id = cya.pdts_provider_id
                    and cya.year = @year
                    and cya.monthno = @endMonth
                    
            left join currentyear_admit_note_xref xref
                on cya.currentyear_admit_id = xref.currentyear_admit_id
                
            left join note n
                on xref.note_id = n.note_id
                
        where prov.pdts_provider_id = p.pdts_provider_id
    ) as note
	from provider p
		left join specialty s
			on p.specialty_id = s.specialty_id
        
		join facility f
			on p.coid = f.coid
	where p.coid = @coid
END

