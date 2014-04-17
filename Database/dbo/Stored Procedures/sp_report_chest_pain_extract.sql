CREATE PROCEDURE [dbo].[sp_report_chest_pain_extract]
	(
		@beginDate datetime,
		@endDate datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select distinct 
		a.coid, 
		f.name as facility_name,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = a.coid
				and arrival_event_date between @beginDate and @endDate
				and chest_pain_diagnosis_id = 2
		) as acs_volume,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = a.coid
				and arrival_event_date between @beginDate and @endDate
				and chest_pain_mode_of_arrival_id = 1
		) as ems_volume,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = a.coid
				and arrival_event_date between @beginDate and @endDate
				and chest_pain_diagnosis_id = 2
				and chest_pain_mode_of_arrival_id = 1
		) as acs_ems_volume,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = a.coid
				and arrival_event_date between @beginDate and @endDate
				and chest_pain_mode_of_arrival_id = 2
		) as walkin_volume,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = a.coid
				and arrival_event_date between @beginDate and @endDate
				and chest_pain_diagnosis_id = 2
				and chest_pain_mode_of_arrival_id = 2
		) as acs_walkin_volume,
		isnull((
			select avg(datediff(mi, x.arrival_event_date, x.patient_departs_floor_date))
			from chest_pain_patient x with (nolock)
				join chest_pain_patient_symptom y with (nolock)
					on x.chest_pain_patient_id = y.chest_pain_patient_id
						and y.chest_pain_master_symptom_id = 1
			where x.coid = a.coid
				and x.arrival_event_date between @beginDate and @endDate
				and x.arrival_event_date is not null
				and x.patient_departs_floor_date is not null
		), 0) as avg_chest_pain_los
	from chest_pain_patient a with (nolock)
		join facility f with (nolock)
			on a.coid = f.coid
	where a.coid not in ('16826')
		and arrival_event_date between @beginDate and @endDate
	order by f.name;
END

