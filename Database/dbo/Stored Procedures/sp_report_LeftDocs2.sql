CREATE procedure [dbo].[sp_report_LeftDocs2]
	(
		@dischargeFrom datetime,
		@dischargeTo datetime
	)
as
begin
	select 
		p.provider_id,
		p.coid,
		f.name as facility_name,
		isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
		s.long_name as specialty,
		case 
			when p.other_reason_text is null then pr.long_name
			when len(ltrim(rtrim(p.other_reason_text))) = 0 then pr.long_name
			else p.other_reason_text 
		end as reason_leaving,
		p.left_date,
		sg.name as specialty_group,
		pps.name as provider_position_status
	from provider p with (nolock)
		join facility f with (nolock)
			on p.coid = f.coid
	        
		left join specialty s
			on p.specialty_id = s.specialty_id
	        
		left join Physician_Reason pr
			on p.physician_reason_id = pr.physician_reason_id
	        
		left join SpecialtyGroup sg with (nolock)
			on s.specialty_group_id = sg.specialty_group_id
		
		left join ProviderPositionStatus pps with (nolock)
			on p.provider_position_status_id = pps.provider_position_status_id
	where left_date between @dischargeFrom and @dischargeTo
	order by f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
end;

