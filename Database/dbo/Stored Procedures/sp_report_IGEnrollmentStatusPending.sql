CREATE PROCEDURE [dbo].[sp_report_IGEnrollmentStatusPending]
AS
BEGIN
	SET NOCOUNT ON;

	declare @p table 
		(
			division_name varchar(50),
			facility_name varchar(50),
			pdts_provider_id int,
			provider_first_name varchar(50),
			provider_middle_name varchar(50),
			provider_last_name varchar(50),
			start_date datetime,
			provider_credentialing_id int,
			provider_credential_type_id int,
			credential_type varchar(50),
			sent_date datetime,
			approved_date datetime,
			effective_date datetime
		)
		
	insert into @p 
		(
			division_name, 
			facility_name, 
			pdts_provider_id,
			provider_first_name, 
			provider_middle_name, 
			provider_last_name,
			start_date,
			provider_credentialing_id,
			provider_credential_type_id,
			credential_type,
			sent_date,
			approved_date,
			effective_date
		)
    select d.name as division,
		f.name as facility,
		p.pdts_provider_id,
		p.first_name,
		p.middle_name,
		p.last_name,
		p.start_date,
		pc.provider_credentialing_id,
		pc.provider_credential_type_id,
		pct.name,
		pc.sent_date,
		pc.approved_date,
		pc.effective_date
    from division d with (nolock)
		join facility f with (nolock)
			on d.division_id = f.division_id
			
		join provider p with (nolock)
			on f.coid = p.coid
			
		join ig_Worksheets ig with (nolock)
			on p.pdts_provider_id = ig.provider_id
			
		left join ProviderCredentialing pc with (nolock)
			on p.pdts_provider_id = pc.pdts_provider_id
			
		left join ProviderCredentialType pct with (nolock)
			on pc.provider_credential_type_id = pct.provider_credential_type_id
	where isnull(ig.CredCompletedFlag, 'N') = 'N'
		and igstatus_id = 2
	
	select division_name, 
		facility_name, 
		provider_first_name, 
		provider_middle_name, 
		provider_last_name,
		case datepart (mm, start_date)
			when 1 then 'January'
			when 2 then 'February'
			when 3 then 'March'
			when 4 then 'April'
			when 5 then 'May'
			when 6 then 'June'
			when 7 then 'July'
			when 8 then 'August'
			when 9 then 'September'
			when 10 then 'October'
			when 11 then 'November'
			when 12 then 'December'
		end as start_month,
		provider_credential_type_id,
		credential_type,
		sent_date,
		approved_date,
		effective_date,
		(
			select top 1 note
			from ProviderCredentialingNote with (nolock)
			where provider_credentialing_id = a.provider_credentialing_id
			order by create_date desc
		) as most_recent_note
	from @p a
END

grant execute on sp_report_IGEnrollmentStatusPending to LIFESVCPDTS;

