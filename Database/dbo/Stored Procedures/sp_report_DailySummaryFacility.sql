CREATE PROCEDURE [dbo].[sp_report_DailySummaryFacility]
    (
        @coid varchar(5),
        @year int,
        @monthno smallint,
        @day smallint
    )
AS
BEGIN
	SET NOCOUNT ON;
    
    declare @summary table
        (
            coid varchar(5),
            facility_name varchar(100),
            same_store bit,
            top_ten bit,
            top_ten_sort_order int default 0,
            division_id int,
            division varchar(50),
            admissions_today int default 0,
            mtd_admissions int default 0,
            mtd_admissions_budget int default 0,
            mtd_admissions_py int default 0,
            census_today int default 0,
            mtd_census int default 0,
            deliveries_today int default 0,
            mtd_deliveries int default 0,
            er_admits_today int default 0,
            mtd_er_admits int default 0,
            er_visits_today int default 0,
            mtd_er_visits int default 0,
            op_visits_today int default 0,
            mtd_op_visits int default 0,
            ip_surgeries_today int default 0,
            mtd_ip_surgeries int default 0,
            mtd_ip_surgeries_budget int default 0,
            mtd_ip_surgeries_py int default 0,
            op_surgeries_today int default 0,
            mtd_op_surgeries int default 0,
            mtd_op_surgeries_budget int default 0,
            mtd_op_surgeries_py int default 0,
            cath_lab_procedures_today int default 0,
            mtd_cath_lab_procedures int default 0,
            mtd_cath_lab_procedures_py int default 0,
            op_charges_today decimal(18, 2) default 0,
            mtd_op_charges decimal(18, 2) default 0,
            mtd_op_charges_py decimal (18, 2) default 0,
            medicare_admits_today int default 0,
            mtd_medicare_admits int default 0,
            mtd_medicare_admits_py int default 0,
            medicare_patdays_today int default 0,
            mtd_medicare_patdays int default 0,
            mtd_medicare_patdays_py int default 0,
            obs_visits_today INT DEFAULT 0,
            mtd_obs_visits INT DEFAULT 0,
            mtd_obs_visits_py INT DEFAULT 0
        );
     
    insert into @summary (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division)
    select coid, f.name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name
    from facility f with (nolock)
        join division d with (nolock)
            on f.division_id = d.division_id
    where coid = @coid
        and f.active = 1
        and f.division_id is not null
    order by coid;

	IF @coid = '05470'
		BEGIN
			insert into @summary (coid, facility_name, same_store, top_ten, top_ten_sort_order, division_id, division)
			select coid, f.name, same_store, top_ten, top_ten_sort_order, f.division_id, d.name
			from facility f with (nolock)
				join division d with (nolock)
					on f.division_id = d.division_id
			where coid = '02751'
				and f.active = 1
				and f.division_id is not null
			order by coid;      
		END;      
        
    update s
    set s.admissions_today = 
        (
            select isnull(admits, 0)
            from DailyAdmissions with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
       
    update s
    set s.mtd_admissions = 
        (
            select isnull(sum(admits), 0)
            from DailyAdmissions with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;

    update s
    set s.mtd_admissions_budget = 
        (
            select isnull(sum(bya.admits), 0)
            from provider p with (nolock)
                join BudgetYear_Admit bya with (nolock)
                    on p.pdts_provider_id = bya.pdts_provider_id
            where p.coid = s.coid
                and bya.year = @year
                and bya.monthno = @monthno
        )
    from @summary s;
    
    update s
    set s.mtd_admissions_py = 
        (
            select isnull(sum(cya.admits), 0)
            from provider p with (nolock)
                join CurrentYear_Admit cya with (nolock)
                    on p.pdts_provider_id = cya.pdts_provider_id
            where p.coid = s.coid
                and cya.year = @year - 1
                and cya.monthno = @monthno
        )
    from @summary s;
        
    update s
    set s.census_today =
        (
            select isnull(census, 0)
            from DailyCensus with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_census = 
        (
            select isnull(sum(census), 0)
            from DailyCensus with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.deliveries_today = 
        (
            select isnull(deliveries, 0)
            from DailyDeliveries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
        
    update s
    set s.mtd_deliveries = 
        (
            select isnull(sum(deliveries), 0)
            from DailyDeliveries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
        
    update s
    set er_admits_today = 
        (
            select isnull(er_admits, 0)
            from DailyERAdmits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
                    
    update s
    set s.mtd_er_admits = 
        (
            select isnull(sum(er_admits), 0)
            from DailyERAdmits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.er_visits_today = 
        (
            select isnull(er_visits, 0)
            from DailyERVisits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_er_visits = 
        (
            select isnull(sum(er_visits), 0)
            from DailyERVisits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.op_visits_today =
        (
            select isnull(op_visits, 0)
            from DailyOPVisits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_op_visits = 
        (
            select isnull(sum(op_visits), 0)
            from DailyOPVisits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno 
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.ip_surgeries_today =
        (
            select isnull(ip, 0)
            from DailySurgeries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_ip_surgeries = 
        (
            select isnull(sum(ip), 0)
            from DailySurgeries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.mtd_ip_surgeries_budget = 
        (
            select isnull(sum(b.inpatient), 0)
            from provider p with (nolock)
                join BudgetYear_Surgery b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where p.coid = s.coid
                and b.year = @year
                and b.monthno = @monthno
        )
    from @summary s;
    
    update s
    set s.mtd_ip_surgeries_py = 
        (
            select isnull(sum(b.inpatient), 0)
            from provider p with (nolock)
                join CurrentYear_Surgery b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where p.coid = s.coid
                and b.year = @year - 1
                and b.monthno = @monthno
        )
    from @summary s;
     
    update s
    set s.op_surgeries_today =
        (
            select isnull(outp, 0)
            from DailySurgeries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_op_surgeries = 
        (
            select isnull(sum(outp), 0)
            from DailySurgeries with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.mtd_op_surgeries_budget = 
        (
            select isnull(sum(b.outpatient), 0)
            from provider p with (nolock)
                join BudgetYear_Surgery b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where p.coid = s.coid
                and b.year = @year
                and b.monthno = @monthno
        )
    from @summary s;
    
    update s
    set s.mtd_op_surgeries_py = 
        (
            select isnull(sum(b.outpatient), 0)
            from provider p with (nolock)
                join CurrentYear_Surgery b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where p.coid = s.coid
                and b.year = @year - 1
                and b.monthno = @monthno
        )
    from @summary s;
    
    update s
    set s.cath_lab_procedures_today =
        (
            select isnull(cath_lab_procedures, 0)
            from DailyCardiacCathLabProcs with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_cath_lab_procedures = 
        (
            select isnull(sum(cath_lab_procedures), 0)
            from DailyCardiacCathLabProcs with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
 
    update s
    set s.mtd_cath_lab_procedures_py = 
        (
            select isnull(sum(b.cath_lab_procedures), 0)
            from DailyCardiacCathLabProcs b with (nolock)
            where coid = s.coid
                and year = @year - 1
                and monthno = @monthno
                and day <= @day
        )
    from @summary s;
    
    update s
    set s.op_charges_today =
        (
            select isnull(op_charges, 0)
            from DailyOPCharges with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_op_charges =
		(
			select isnull(sum(op_charges), 0)
			from DailyOPCharges with (nolock)
			where coid = s.coid
				and year = @year
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.mtd_op_charges_py =
		(
			select isnull(sum(op_charges), 0)
			from DailyOPCharges with (nolock)
			where coid = s.coid
				and year = @year - 1
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.medicare_admits_today =
        (
            select isnull(admits, 0)
            from DailyMcareAcuteAdmits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_medicare_admits =
		(
			select isnull(sum(admits), 0)
			from DailyMcareAcuteAdmits with (nolock)
			where coid = s.coid
				and year = @year
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.mtd_medicare_admits_py =
		(
			select isnull(sum(admits), 0)
			from DailyMcareAcuteAdmits with (nolock)
			where coid = s.coid
				and year = @year - 1
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.medicare_patdays_today =
        (
            select isnull(pat_days, 0)
            from DailyMcareAcutePatDays with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_medicare_patdays =
		(
			select isnull(sum(pat_days), 0)
			from DailyMcareAcutePatDays with (nolock)
			where coid = s.coid
				and year = @year
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.mtd_medicare_patdays_py =
		(
			select isnull(sum(pat_days), 0)
			from DailyMcareAcutePatDays with (nolock)
			where coid = s.coid
				and year = @year - 1
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.obs_visits_today =
        (
            select isnull(obs_visits, 0)
            from DailyObsVisits with (nolock)
            where coid = s.coid
                and year = @year
                and monthno = @monthno
                and day = @day
        )
    from @summary s
    
    update s
    set s.mtd_obs_visits =
		(
			select isnull(sum(obs_visits), 0)
			from DailyObsVisits with (nolock)
			where coid = s.coid
				and year = @year
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	update s
    set s.mtd_obs_visits_py =
		(
			select isnull(sum(obs_visits), 0)
			from DailyObsVisits with (nolock)
			where coid = s.coid
				and year = @year - 1
				and monthno = @monthno
				and day <= @day
		)
	from @summary s
	
	IF @coid = '05470'
		BEGIN
			UPDATE @summary
			SET admissions_today = admissions_today + (SELECT admissions_today FROM @summary WHERE coid = '02751'),
				mtd_admissions = mtd_admissions + (SELECT mtd_admissions FROM @summary WHERE coid = '02751'),
				mtd_admissions_budget = mtd_admissions_budget + (SELECT mtd_admissions_budget FROM @summary WHERE coid = '02751'),
				mtd_admissions_py = mtd_admissions_py + (SELECT mtd_admissions_py FROM @summary WHERE coid = '02751'),
				census_today = census_today + (SELECT census_today FROM @summary WHERE coid = '02751'),
				mtd_census = mtd_census + (SELECT mtd_census FROM @summary WHERE coid = '02751'),
				deliveries_today = deliveries_today + (SELECT deliveries_today FROM @summary WHERE coid = '02751'),
				mtd_deliveries = mtd_deliveries + (SELECT mtd_deliveries FROM @summary WHERE coid = '02751'),
				er_admits_today = er_admits_today + (SELECT er_admits_today FROM @summary WHERE coid = '02751'),
				mtd_er_admits = mtd_er_admits + (SELECT mtd_er_admits FROM @summary WHERE coid = '02751'),
				er_visits_today = er_visits_today + (SELECT er_visits_today FROM @summary WHERE coid = '02751'),
				mtd_er_visits = mtd_er_visits + (SELECT mtd_er_visits FROM @summary WHERE coid = '02751'),
				op_visits_today = op_visits_today + (SELECT op_visits_today FROM @summary WHERE coid = '02751'),
				mtd_op_visits = mtd_op_visits + (SELECT mtd_op_visits FROM @summary WHERE coid = '02751'),
				ip_surgeries_today = ip_surgeries_today + (SELECT ip_surgeries_today FROM @summary WHERE coid = '02751'),
				mtd_ip_surgeries = mtd_ip_surgeries + (SELECT mtd_ip_surgeries FROM @summary WHERE coid = '02751'),
				mtd_ip_surgeries_budget = mtd_ip_surgeries_budget + (SELECT mtd_ip_surgeries_budget FROM @summary WHERE coid = '02751'),
				mtd_ip_surgeries_py = mtd_ip_surgeries_py + (SELECT mtd_ip_surgeries_py FROM @summary WHERE coid = '02751'),
				op_surgeries_today = op_surgeries_today + (SELECT op_surgeries_today FROM @summary WHERE coid ='02751'),
				mtd_op_surgeries = mtd_op_surgeries + (SELECT mtd_op_surgeries FROM @summary WHERE coid = '02751'),
				mtd_op_surgeries_budget = mtd_op_surgeries_budget + (SELECT mtd_op_surgeries_budget FROM @summary WHERE coid = '02751'),
				mtd_op_surgeries_py = mtd_op_surgeries_py + (SELECT mtd_op_surgeries_py FROM @summary WHERE coid = '02751'),
				cath_lab_procedures_today = cath_lab_procedures_today + (SELECT cath_lab_procedures_today FROM @summary WHERE coid = '02751'),
				mtd_cath_lab_procedures = mtd_cath_lab_procedures + (SELECT mtd_cath_lab_procedures FROM @summary WHERE coid = '02751'),
				mtd_cath_lab_procedures_py = mtd_cath_lab_procedures_py + (SELECT mtd_cath_lab_procedures_py FROM @summary WHERE coid = '02751'),
				op_charges_today = op_charges_today + (SELECT op_charges_today FROM @summary WHERE coid = '02751'),
				mtd_op_charges = mtd_op_charges + (SELECT mtd_op_charges FROM @summary WHERE coid = '02751'),
				mtd_op_charges_py = mtd_op_charges_py + (SELECT mtd_op_charges_py FROM @summary WHERE coid = '02751'),
				medicare_admits_today = medicare_admits_today + (SELECT medicare_admits_today FROM @summary WHERE coid = '02751'),
				mtd_medicare_admits = mtd_medicare_admits + (SELECT mtd_medicare_admits FROM @summary WHERE coid = '02751'),
				mtd_medicare_admits_py = mtd_medicare_admits_py + (SELECT mtd_medicare_admits_py FROM @summary WHERE coid = '02751'),
				medicare_patdays_today = medicare_patdays_today + (SELECT medicare_patdays_today FROM @summary WHERE coid = '02751'),
				mtd_medicare_patdays = mtd_medicare_patdays + (SELECT mtd_medicare_patdays FROM @summary WHERE coid = '02751'),
				mtd_medicare_patdays_py = mtd_medicare_patdays_py + (SELECT mtd_medicare_patdays_py FROM @summary WHERE coid = '02751'),
				obs_visits_today = obs_visits_today + (SELECT obs_visits_today FROM @summary WHERE coid = '02751'),
				mtd_obs_visits = mtd_obs_visits + (SELECT mtd_obs_visits FROM @summary WHERE coid = '02751'),
				mtd_obs_visits_py = mtd_obs_visits_py + (SELECT mtd_obs_visits_py FROM @summary WHERE coid = '02751')
			WHERE coid = '05470'

			DELETE
			FROM @summary
			WHERE coid = '02751';          
		END;      

    select 
        coid,
        facility_name,
        same_store,
        top_ten,
        top_ten_sort_order,
        division_id,
        division,
        isnull(admissions_today, 0) as admissions_today,
        isnull(mtd_admissions, 0) as mtd_admissions,
        isnull(mtd_admissions_budget, 0) as mtd_admissions_budget,
        isnull(mtd_admissions_py, 0) as mtd_admissions_py,
        isnull(census_today, 0) as census_today,
        isnull(mtd_census, 0) as mtd_census,
        isnull(deliveries_today, 0) as deliveries_today,
        isnull(mtd_deliveries, 0) as mtd_deliveries,
        isnull(er_admits_today, 0) as er_admits_today,
        isnull(mtd_er_admits, 0) as mtd_er_admits,
        isnull(er_visits_today, 0) as er_visits_today,
        isnull(mtd_er_visits, 0) as mtd_er_visits,
        isnull(op_visits_today, 0) as op_visits_today,
        isnull(mtd_op_visits, 0) as mtd_op_visits,
        isnull(ip_surgeries_today, 0) as ip_surgeries_today,
        isnull(mtd_ip_surgeries, 0) as mtd_ip_surgeries,
        isnull(mtd_ip_surgeries_budget, 0) as mtd_ip_surgeries_budget,
        isnull(mtd_ip_surgeries_py, 0) as mtd_ip_surgeries_py,
        isnull(op_surgeries_today, 0) as op_surgeries_today,
        isnull(mtd_op_surgeries, 0) as mtd_op_surgeries,
        isnull(mtd_op_surgeries_budget, 0) as mtd_op_surgeries_budget,
        isnull(mtd_op_surgeries_py, 0) as mtd_op_surgeries_py,
        isnull(cath_lab_procedures_today, 0) as cath_lab_procedures_today,
        isnull(mtd_cath_lab_procedures, 0) as mtd_cath_lab_procedures,
        isnull(mtd_cath_lab_procedures_py, 0) as mtd_cath_lab_procedures_py,
        isnull(op_charges_today, 0) as op_charges_today,
		isnull(mtd_op_charges, 0) as mtd_op_charges,
		isnull(mtd_op_charges_py, 0) as mtd_op_charges_py,
		isnull(medicare_admits_today, 0) as medicare_admits_today,
        isnull(mtd_medicare_admits, 0) as mtd_medicare_admits,
        isnull(mtd_medicare_admits_py, 0) as mtd_medicare_admits_py,
        isnull(medicare_patdays_today, 0) as medicare_patdays_today,
        isnull(mtd_medicare_patdays, 0) as mtd_medicare_patdays,
        isnull(mtd_medicare_patdays_py, 0) as mtd_medicare_patdays_py,
        ISNULL(obs_visits_today, 0) AS obs_visits_today,
        ISNULL(mtd_obs_visits, 0) AS mtd_obs_visits,
        ISNULL(mtd_obs_visits_py, 0) as mtd_obs_visits_py
    from @summary
END

grant execute on sp_report_DailySummaryFacility to LIFESVCPDTS

