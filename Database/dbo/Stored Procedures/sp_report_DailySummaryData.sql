CREATE PROCEDURE [dbo].[sp_report_DailySummaryData]
    (
        @reportDate datetime
    )
AS
BEGIN
	SET NOCOUNT ON;

    declare @daily table
        (
            coid varchar(5),
            facility_name varchar(50),
            daily_admissions int default 0,
            daily_cardiac_cath_lab_procs int default 0,
            daily_census int default 0,
            daily_deliveries int default 0,
            daily_eradmits int default 0,
            daily_ervisits int default 0,
            daily_mcare_acute_admits int default 0,
            daily_mcare_acute_patdays int default 0,
            daily_op_charges decimal(18, 2) default 0,
            daily_op_visits int default 0,
            daily_ip_surgeries int default 0,
            daily_op_surgeries int default 0,
			daily_observation_visits INT DEFAULT 0
        )
    insert into @daily (coid, facility_name)
    select coid, name
    from facility where division_id is not null
        and active = 1;
            
    update d
    set d.daily_admissions = 
                            (
                                select isnull(admits, 0)
                                from DailyAdmissions with (nolock)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_cardiac_cath_lab_procs =
                            (
                                select isnull(cath_lab_procedures, 0)
                                from DailyCardiacCathLabProcs with (nolock)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_census =
                            (
                                select isnull(census, 0)
                                from DailyCensus with (nolock)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d;
    
    update d
    set d.daily_deliveries =
                            (
                                select isnull(deliveries, 0)
                                from DailyDeliveries WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_eradmits =
                            (
                                select isnull(er_admits, 0)
                                from DailyERAdmits WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_ervisits = 
                            (
                                select isnull(er_visits, 0)
                                from DailyERVisits WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_mcare_acute_admits =
                            (
                                select isnull(admits, 0)
                                from DailyMcareAcuteAdmits WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_mcare_acute_patdays = 
                            (
                                select isnull(pat_days, 0)
                                from DailyMCareAcutePatDays WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_op_charges = 
                            (
                                select isnull(op_charges, 0)
                                from DailyOPCharges WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_op_visits = 
                            (
                                select isnull(op_visits, 0)
                                from DailyOPVisits WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_ip_surgeries = 
                            (
                                select isnull(ip, 0)
                                from DailySurgeries WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
    update d
    set d.daily_op_surgeries = 
                            (
                                select isnull(outp, 0)
                                from DailySurgeries WITH (NOLOCK)
                                where coid = d.coid
                                    and year = datepart(yyyy, @reportDate)
                                    and monthno = datepart(mm, @reportDate)
                                    and day = datepart(dd, @reportDate)
                            )
    from @daily d
    
	UPDATE d
	SET d.daily_observation_visits = 
		(
			SELECT ISNULL(obs_visits, 0)
			FROM dbo.DailyObsVisits WITH (NOLOCK)
			WHERE coid = d.coid
				AND year = DATEPART(yyyy, @reportDate)
				AND monthno = DATEPART(mm, @reportDate)
				AND day = DATEPART(dd, @reportDate)
		)
	FROM @daily d

	select *
	from @daily
	order by facility_name
END

