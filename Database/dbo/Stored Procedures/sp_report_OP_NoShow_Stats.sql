CREATE PROCEDURE [dbo].[sp_report_OP_NoShow_Stats]
	(
		@coid varchar(5) = null, 
		@reportDate datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

	declare @month int
	declare @year int

	select @month = datepart(mm, @reportDate);
	select @year = datepart(yyyy, @reportDate);

	declare @t table
		(
			coid varchar(5),
			hospital varchar(50),
			group_name varchar(50),
			number_no_shows int,
			unable_to_reach int,
			not_imaging_patient int,
			attended_appointment int,
			able_to_reschedule int,
			not_able_to_reschedule int
		);

	insert into @t (coid, hospital, group_name, number_no_shows, unable_to_reach, not_imaging_patient, attended_appointment, able_to_reschedule, not_able_to_reschedule)
    select 
		a.coid, 
		f.name as hospital,
		d.name as group_name,
		count(f.name) as number_no_shows,
		(
			select count(distinct aa.op_imaging_followup_patient_id)
			from op_imaging_followup_patient aa with (nolock)
				join op_imaging_followup_patient_attempt bb with (nolock)
					on aa.op_imaging_followup_patient_id = bb.op_imaging_followup_patient_id
			where aa.coid = a.coid
				and datepart(mm, aa.appointment_date) = @month
				and datepart(yyyy, aa.appointment_date) = @year
				and bb.op_imaging_followup_reach_patient_id in (2, 3, 4)
		) as unable_to_reach,
		(
			select count(distinct aa.op_imaging_followup_patient_id)
			from op_imaging_followup_patient aa with (nolock)
				join op_imaging_followup_patient_attempt bb with (nolock)
					on aa.op_imaging_followup_patient_id = bb.op_imaging_followup_patient_id
			where aa.coid = a.coid
				and datepart(mm, aa.appointment_date) = @month
				and datepart(yyyy, aa.appointment_date) = @year
				and bb.op_imaging_followup_reach_patient_id = 6
		) as not_imaging_patient,
		(
			select count(distinct aa.op_imaging_followup_patient_id)
			from op_imaging_followup_patient aa with (nolock)
				join op_imaging_followup_patient_attempt bb with (nolock)
					on aa.op_imaging_followup_patient_id = bb.op_imaging_followup_patient_id
			where aa.coid = a.coid
				and datepart(mm, aa.appointment_date) = @month
				and datepart(yyyy, aa.appointment_date) = @year
				and bb.op_imaging_followup_reach_patient_id = 5
		) as attended_appointment,
		(
			select count(1)
			from op_imaging_followup_patient with (nolock)
			where coid = a.coid
				and datepart(mm, appointment_date) = @month
				and datepart(yyyy, appointment_date) = @year
				and able_to_reschedule = 1
		) as able_to_reschedule,
		(
			select count(1)
			from op_imaging_followup_patient with (nolock)
			where coid = a.coid
				and datepart(mm, appointment_date) = @month
				and datepart(yyyy, appointment_date) = @year
				and able_to_reschedule = 0
		) as not_able_to_reschedule
	from op_imaging_followup_patient a with (nolock)
		join Facility f with (nolock)
			on a.coid = f.coid

		join division d with (nolock)
			on f.division_id = d.division_id
	where datepart(mm, a.appointment_date) = @month
		and datepart(yyyy, a.appointment_date) = @year
	group by a.coid, f.name, d.name
	order by f.name;

	if @coid is not null
		begin
			delete
			from @t
			where coid <> @coid
		end;

	select *
	from @t
	order by hospital;
END

