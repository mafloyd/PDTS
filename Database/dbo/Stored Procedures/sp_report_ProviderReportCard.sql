CREATE procedure [dbo].[sp_report_ProviderReportCard]
    (
        @coid varchar(5),
        @year int,
        @divisionId int = 0
    )
as
begin
	if @divisionId is null
		begin
			select @divisionId = 0;
		end
		
    if @coid is not null
        begin
            select 
                d.division_id, 
                d.name as division_name, 
                f.coid,
                f.name as facility_name,
                s.specialty_id,
                s.long_name as specialty,
                p.provider_contract_type_id,
                case pct.provider_contract_type_id 
                    when 1 then 'RA'
                    when 2 then 'EA'
                    when 3 then 'PSA'
                    when 4 then 'NA' end as contract_type,
                p.provider_id,
                isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
                p.signed_date,
                p.projected_start_date,
                p.start_date,
                ps.name as position_name,
                p.budgeted_start_date
            from division d with (nolock)
                join facility f with (nolock)
                    on d.division_id = f.division_id
                    
                join provider p with (nolock)
                    on f.coid = p.coid
                
                join specialty s with (nolock)
                    on p.specialty_id = s.specialty_id
                    
                left join ProviderContractType pct
                    on p.provider_contract_type_id = pct.provider_contract_type_id
                    
                join ProviderPositionStatus ps
                    on p.provider_position_status_id = ps.provider_position_status_id
            where p.coid = @coid
				and p.approved_for_scorecard = 1
                and d.division_id > 1
                and f.active = 1
                and p.provider_recruitment_status_id in (1, 2)
                and ((datepart(yyyy, p.budgeted_start_date) = @year) or (datepart(yyyy, p.projected_start_date) = @year))
            order by d.name, f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
        end
    else if @divisionId = 0 or @divisionId = 1
		begin
			select
                d.division_id, 
                d.name as division_name, 
                f.coid,
                f.name as facility_name,
                s.specialty_id,
                s.long_name as specialty,
                p.provider_contract_type_id,
                case pct.provider_contract_type_id 
                    when 1 then 'RA'
                    when 2 then 'EA'
                    when 3 then 'PSA'
                    when 4 then 'NA' end as contract_type,
                p.provider_id,
                isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
                p.signed_date,
                p.projected_start_date,
                p.start_date,
                ps.name as position_name,
                p.budgeted_start_date
            from division d with (nolock)
                join facility f with (nolock)
                    on d.division_id = f.division_id
                    
                join provider p with (nolock)
                    on f.coid = p.coid
                
                join specialty s with (nolock)
                    on p.specialty_id = s.specialty_id
                    
                left join ProviderContractType pct
                    on p.provider_contract_type_id = pct.provider_contract_type_id
                    
                join ProviderPositionStatus ps
                    on p.provider_position_status_id = ps.provider_position_status_id
            where d.division_id > 1
                and f.active = 1
                and p.provider_recruitment_status_id in (1, 2)
                and ((datepart(yyyy, p.budgeted_start_date) = @year) or (datepart(yyyy, p.projected_start_date) = @year))
                and p.approved_for_scorecard = 1
            order by d.name, f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
		end
    else if @divisionId > 1
        begin
            select
                d.division_id, 
                d.name as division_name, 
                f.coid,
                f.name as facility_name,
                s.specialty_id,
                s.long_name as specialty,
                p.provider_contract_type_id,
                case pct.provider_contract_type_id 
                    when 1 then 'RA'
                    when 2 then 'EA'
                    when 3 then 'PSA'
                    when 4 then 'NA' end as contract_type,
                p.provider_id,
                isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
                p.signed_date,
                p.projected_start_date,
                p.start_date,
                ps.name as position_name,
                p.budgeted_start_date
            from division d with (nolock)
                join facility f with (nolock)
                    on d.division_id = f.division_id
                    
                join provider p with (nolock)
                    on f.coid = p.coid
                
                join specialty s with (nolock)
                    on p.specialty_id = s.specialty_id
                    
                left join ProviderContractType pct
                    on p.provider_contract_type_id = pct.provider_contract_type_id
                    
                join ProviderPositionStatus ps
                    on p.provider_position_status_id = ps.provider_position_status_id
            where d.division_id = @divisionId
                and f.active = 1
                and p.provider_recruitment_status_id in (1, 2)
                and ((datepart(yyyy, p.budgeted_start_date) = @year) or (datepart(yyyy, p.projected_start_date) = @year))
                and p.approved_for_scorecard = 1
            order by d.name, f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
        end
end

