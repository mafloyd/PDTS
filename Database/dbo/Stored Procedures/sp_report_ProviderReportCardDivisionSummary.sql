CREATE procedure [dbo].[sp_report_ProviderReportCardDivisionSummary]
(
	@year int,
	@divisionId int = 0
)
as
begin
	declare @pdts_provider_id int
	--declare @history_date datetime
	--declare @last_day_of_month int

	--select @last_day_of_month = 
	--	(select case @month
	--		when 1 then 31
	--		when 2 then 28
	--		when 3 then 31
	--		when 4 then 30
	--		when 5 then 31
	--		when 6 then 30
	--		when 7 then 31
	--		when 8 then 31
	--		when 9 then 30
	--		when 10 then 31
	--		when 11 then 30
	--		when 12 then 31
	--	end);
		
	--select @history_date = cast(@year as varchar(4)) + '-' + cast(@month as varchar(2)) + '-' + @last_day_of_month;
	
	declare @report_card table
		(
			division varchar(50),
			coid varchar(5),
			facility varchar(50),
			pcp bit,
			specialist bit,
			signed_date datetime,
			start_date datetime,
			on_hold bit,
			specialty varchar(50),
			agreement_type int
		);
	
	--declare cur cursor fast_forward read_only for
	--select distinct pdts_provider_id 
	--from Provider_History with (nolock)
	--where datepart(mm, start_date) = @month
	--	and datepart(yyyy, start_date) = @year
	--	and provider_recruitment_status_id = 1
	--	and provider_recruitment_status_date <= @report_card_date
		
	--open cur
	
	--fetch next from cur
	--into @pdts_provider_id 
	
	--while @@fetch_status = 0
	--	 begin
	--		insert into @report_card
	--		(
	--			division,
	--			coid,
	--			facility,
	--			pcp,
	--			specialist,
	--			signed_date,
	--			start_date,
	--			on_hold
	--		)
	--		select 
	--			d.name as division, 
	--			f.coid,
	--			f.name as facility, 
	--			case sg.specialty_group_id
	--				when 1 then 1
	--			end as pcp,
	--			case sg.specialty_group_id
	--				when 2 then 1
	--			end as specialist,
	--			p.signed_date,
	--			p.start_date,
	--			p.on_hold
	--		from division d with (nolock)
	--			join facility f with (nolock)
	--				on d.division_id = f.division_id
					
	--			join Provider_History p with (nolock)
	--				on f.coid = p.coid
					
	--			left join specialty s with (nolock)
	--				on p.specialty_id = s.specialty_id
					
	--			left join SpecialtyGroup sg with (nolock)
	--				on s.specialty_group_id = sg.specialty_group_id
	--		where p.provider_recruitment_status_id = 1
			
	--		fetch next from cur
	--		into @pdts_provider_id
	--	 end
	
	--close cur
	--deallocate cur
	
	if @divisionId = 0 or @divisionId = 1
		begin
			insert into @report_card
				(
					division,
					coid,
					facility,
					pcp,
					specialist,
					signed_date,
					start_date,
					on_hold,
					specialty,
					agreement_type
				)
			select 
				d.name as division, 
				f.coid,
				f.name as facility, 
				case sg.specialty_group_id
					when 1 then 1
				end as pcp,
				case sg.specialty_group_id
					when 2 then 1
				end as specialist,
				p.signed_date,
				p.start_date,
				p.on_hold,
				isnull(s.long_name, 'None Assigned'),
				p.provider_contract_type_id
			from division d with (nolock)
				join facility f with (nolock)
					on d.division_id = f.division_id
					
				join Provider p with (nolock)
					on f.coid = p.coid
					
				left join specialty s with (nolock)
					on p.specialty_id = s.specialty_id
					
				left join SpecialtyGroup sg with (nolock)
					on s.specialty_group_id = sg.specialty_group_id
			where p.provider_recruitment_status_id = 1
				and p.approved_for_scorecard = 1;
		end
	else
		begin
		insert into @report_card
				(
					division,
					coid,
					facility,
					pcp,
					specialist,
					signed_date,
					start_date,
					on_hold,
					specialty,
					agreement_type
				)
			select 
				d.name as division, 
				f.coid,
				f.name as facility, 
				case sg.specialty_group_id
					when 1 then 1
				end as pcp,
				case sg.specialty_group_id
					when 2 then 1
				end as specialist,
				p.signed_date,
				p.start_date,
				p.on_hold,
				isnull(s.long_name, 'None Assigned'),
				p.provider_contract_type_id
			from division d with (nolock)
				join facility f with (nolock)
					on d.division_id = f.division_id
					
				join Provider p with (nolock)
					on f.coid = p.coid
					
				left join specialty s with (nolock)
					on p.specialty_id = s.specialty_id
					
				left join SpecialtyGroup sg with (nolock)
					on s.specialty_group_id = sg.specialty_group_id
			where p.provider_recruitment_status_id = 1
				and p.approved_for_scorecard = 1
				and d.division_id = @divisionId
		end
	
	select *
	from @report_card
	order by division, facility
end

