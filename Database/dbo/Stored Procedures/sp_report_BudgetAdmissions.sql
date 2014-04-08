CREATE procedure [dbo].[sp_report_BudgetAdmissions]
    (
        @year int,
        @coid varchar(5),
        @division_id int = null
    )
as
begin
    if @division_id is null
        begin
            SELECT DISTINCT 
                p.pdts_provider_id,
                p.PROVIDER_ID, 
                p.FIRST_NAME, 
                p.MIDDLE_NAME, 
                p.LAST_NAME, 
                p.DOB, 
                f.NAME AS facility_name, 
                s.LONG_NAME AS specialty,
                ISNULL(b.provider_position_status_id, 0) AS provider_position_status_id,
                b.name as status,
                p.start_date,
                p.left_date,
                f.division_id,
                d.name as division_name,
                isnull(p.physician_group, 'None') as physician_group,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 3) as year1Admits,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 2) as year2Admits,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 1 and monthno < 9) as year3Admits,
                (select isnull(sum(admits), 0) from budgetyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year) as budgetAdmits,
                isnull((select period9_admits + period10_admits + period11_admits + period12_admits from ProjectedAdmits where pdts_provider_id = p.pdts_provider_id and year = (@year - 1)), 0) as projectedAdmits,
                (select top 1 note from note where pdts_provider_id = p.pdts_provider_id and note_type_id = 3 and budget_year = @year order by create_date desc) as note
            FROM Provider p 
                JOIN Facility f 
                    ON p.COID = f.COID 
                    
                join Division d
                    on f.division_id = d.division_id
                LEFT OUTER JOIN Specialty s 
                    ON p.SPECIALTY_ID = s.SPECIALTY_ID
                
                left outer join ProviderPositionStatus b
	            on p.provider_position_status_id = b.provider_position_status_id
            WHERE        (p.COID = @coid) and s.short_name is not null
            ORDER BY p.provider_id
        end
    else
        begin
        SELECT DISTINCT
                p.pdts_provider_id,
                p.PROVIDER_ID, 
                p.FIRST_NAME, 
                p.MIDDLE_NAME, 
                p.LAST_NAME, 
                p.DOB, 
                f.NAME AS facility_name, 
                s.LONG_NAME AS specialty,
                b.provider_position_status_id,
                b.name as status,
                p.start_date,
                p.left_date,
                f.division_id,
                d.name as division_name,
                isnull(p.physician_group, 'None') as physician_group,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 3) as year1Admits,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 2) as year2Admits,
                (select isnull(sum(admits), 0) from currentyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year - 1 and monthno < 9) as year3Admits,
                (select isnull(sum(admits), 0) from budgetyear_admit where pdts_provider_id = p.pdts_provider_id and year = @year) as budgetAdmits,
                isnull((select period9_admits + period10_admits + period11_admits + period12_admits from ProjectedAdmits where pdts_provider_id = p.pdts_provider_id and year = (@year - 1)), 0) as projectedAdmits,
                (select top 1 note from note where pdts_provider_id = p.pdts_provider_id and note_type_id = 3 and budget_year = @year order by create_date desc) as note
            FROM Provider p 
                JOIN Facility f 
                    ON p.COID = f.COID 
                    
                join Division d
                    on f.division_id = d.division_id
                LEFT OUTER JOIN Specialty s 
                    ON p.SPECIALTY_ID = s.SPECIALTY_ID
                
                left outer join ProviderPositionStatus b
	            on p.provider_position_status_id = b.provider_position_status_id
            WHERE f.division_id = @division_id and s.short_name is not null
            ORDER BY p.provider_id
        end
end

