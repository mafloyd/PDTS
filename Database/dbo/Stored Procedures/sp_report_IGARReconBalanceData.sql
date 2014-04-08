CREATE procedure [dbo].[sp_report_IGARReconBalanceData]
as
begin
	set nocount on;
	
	declare @ig table
		(
			worksheet_id int,
			division varchar(50),
			physician varchar(50),
			facility varchar(50),
			specialty varchar(50),
			practicetype_desc varchar(50),
			current_month int,
			ar_current_month decimal (11, 2),
			ar_prior_month decimal (11, 2),
			current_ar_risk varchar(50),
			last_ar_risk varchar(50),
			ar_note varchar(max)
		)
	
	insert into @ig
		(
			worksheet_id,
			division,
			physician,
			facility,
			specialty,
			practicetype_desc,
			current_month,
			ar_current_month
		)
	select iw.worksheet_id, 
		d.name as division,
		p.full_name as physician,
		f.short_name as facility,
		s.long_name as specialty,
		pt.practicetype_desc,
		(select isnull(max(month), 0) from ig_Worksheet_CashRcpts where worksheet_id = iw.worksheet_id) as current_month,
		isnull((
			select top 1 ar_0_30
			from ig_Worksheet_CashRcpts with (nolock)
			where worksheet_id = iw.worksheet_id
			order by month desc
		), 0) as ar_current_month
	from ig_Worksheets iw with (nolock)
		join Provider p with (nolock)
			on iw.provider_id = p.pdts_provider_id
			
		join Facility f with (nolock)
			on p.coid = f.coid
		
		join Division d with (nolock)
			on f.division_id = d.division_id
			
		left join Specialty s with (nolock)
			on p.specialty_id = s.specialty_id
			
		left join ig_PracticeType pt with (nolock)
			on iw.ig_practicetype_id = pt.practicetype_id
		
	update @ig
	set current_ar_risk = 
		(
			select top 1 isnull(igriskstatus_desc, 'Just Started')
			from ig_RiskStatus with (nolock)
			where igriskstatus_id = 
				(
					select top 1 ar_risk_status
					from ig_Worksheet_CashRcpts
					where worksheet_id = ig.worksheet_id
						and month = ig.current_month
				)
		)
	from @ig ig
	
	update @ig
	set last_ar_risk =
		(
			select top 1 isnull(igriskstatus_desc, 'Just Started')
			from ig_RiskStatus with (nolock)
			where igriskstatus_id = 
				(
					select top 1 ar_risk_status
					from ig_Worksheet_CashRcpts
					where worksheet_id = ig.worksheet_id
						and month = (ig.current_month - 1)
				)
		)
	from @ig ig

	update @ig
	set ar_current_month =
		(
			select ar_total
			from ig_worksheet_CashRcpts with (nolock)
			where worksheet_id = ig.worksheet_id
				and month = ig.current_month
		)
	from @ig ig
		
	update @ig
	set ar_prior_month = 
		(
			select ar_total
			from ig_Worksheet_CashRcpts with (nolock)
			where worksheet_id = ig.worksheet_id
				and month = (ig.current_month - 1)
		)
	from @ig ig

	update @ig
	set ar_note = 
		(
			select top 1 c.ws_note_text
			from ig_Worksheet_CashRcpts a with (nolock)
				join ig_Worksheet_CashRcpts_Note_Xref b with (nolock)
					on a.worksheet_id = ig.worksheet_id
						and a.month = ig.current_month
						
				join ig_Worksheet_Notes c with (nolock)
					on b.ws_note_id = c.ws_note_id
						and c.ws_note_type_id = 7
			where a.worksheet_id = ig.worksheet_id
				and c.worksheet_id = ig.worksheet_id
		)
	from @ig ig
	
	update @ig
	set current_ar_risk = 'Just Started'
	where current_ar_risk is null;
	
	update @ig
	set last_ar_risk = 'Just Started'
	where last_ar_risk is null;
	
	update @ig
	set ar_current_month = 0
	where ar_current_month is null;
	
	update @ig
	set ar_prior_month = 0
	where ar_prior_month is null;
	
	select *
	from @ig
end

