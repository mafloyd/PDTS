CREATE PROCEDURE [dbo].[sp_chestpain_ems_summary]
	(
		@coid varchar(5),
		@reportDate datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

	select f.name as facility_name,
		(
			select count(1)
			from chest_pain_patient with (nolock) 
			where coid = @coid 
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
		) as total_patients,
		(
			select count(1)
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and chest_pain_mode_of_arrival_id = 2
		) as ems_patient,
		(
			select avg(datediff(mi, symptom_onset_date, nine11_call_date)) as symptoms_to_nine11
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and symptom_onset_date is not null
				and nine11_call_date is not null
		) as symptoms_to_nine11,
		(
			select avg(datediff(mi, first_med_contact_date, initial_ecg_date))
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and first_med_contact_date is not null
				and initial_ecg_date is not null
		) as first_medical_response_to_ecg,
		(
			select avg(datediff(mi, nine11_call_date, first_med_contact_date))
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and nine11_call_date is not null
				and first_med_contact_date is not null
		) as nine11_to_first_medical_response,
		(
			select avg(datediff(mi, nine11_call_date, initial_ecg_date))
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and nine11_call_date is not null
				and initial_ecg_date is not null
		) as nine11_to_ecg,
		(
			select avg(datediff(mi, nine11_call_date, arrival_event_date))
			from chest_pain_patient with (nolock)
			where coid = @coid
				and datepart(mm, arrival_event_date) = datepart(mm, @reportDate) 
				and datepart(yyyy, arrival_event_date) = datepart(yyyy, @reportDate)
				and nine11_call_date is not null
				and arrival_event_date is not null
		) as nine11_to_ed_arrival
	from facility f
	where coid = @coid
END

