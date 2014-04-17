CREATE PROCEDURE [dbo].[sp_report_provider_practice]
	(
		@pdts_provider_id int,
		@preferred bit = 0,
		@practice_number int = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	declare @t table
		(
			provider_practice_id int,
			dba_name varchar(100),
			office_manager_first_name varchar(50),
			office_manager_last_name varchar(50),
			legal_entity varchar(100),
			tax_id varchar(50),
			practice_management_system varchar(50),
			pm_projected_implementation_date datetime,
			pm_system_account_number varchar(50),
			payroll_system varchar(50),
			sequence int identity (1, 1)
		);

	if @preferred = 1
		begin
			if exists
				(
					select 1
					from ProviderPracticeXref xref with (nolock)
					where pdts_provider_id = @pdts_provider_id
						and preferred = 1
				)
				begin
					insert into @t 
						(
							provider_practice_id,
							dba_name,
							office_manager_first_name,
							office_manager_last_name,
							legal_entity,
							tax_id,
							practice_management_system,
							pm_projected_implementation_date,
							pm_system_account_number,
							payroll_system
						)
					select pp.provider_practice_id,
						pp.dba_name as practice_name,
						pp.office_manager_first_name,
						pp.office_manager_last_name,
						pp.legal_entity,
						pp.tax_id,
						case isnull(pp.provider_practice_management_system_id, 0)
							when 0 then null
							when 4 then pp.other_practice_management_system
							else ppms.name
						end as practice_management_system,
						pp.pm_projected_implementation_date,
						pp.pm_system_account_number,
						pp.payroll_system
					from ProviderPracticeXref xref with (nolock)
						join ProviderPractice pp with (nolock)
							on xref.provider_practice_id = pp.provider_practice_id

						left join provider_practice_management_system ppms with (nolock)
							on pp.provider_practice_management_system_id = ppms.provider_practice_managment_system_id
					where xref.pdts_provider_id = @pdts_provider_id
						and preferred = 1
				end;
		end;

	insert into @t 
		(
			provider_practice_id,
			dba_name,
			office_manager_first_name,
			office_manager_last_name,
			legal_entity,
			tax_id,
			practice_management_system,
			pm_projected_implementation_date,
			pm_system_account_number,
			payroll_system
		)
	select top 3 pp.provider_practice_id,
		pp.dba_name as practice_name,
		pp.office_manager_first_name,
		pp.office_manager_last_name,
		pp.legal_entity,
		pp.tax_id,
		case isnull(pp.provider_practice_management_system_id, 0)
			when 0 then null
			when 4 then pp.other_practice_management_system
			else ppms.name
		end as practice_management_system,
		pp.pm_projected_implementation_date,
		pp.pm_system_account_number,
		pp.payroll_system
	from ProviderPracticeXref xref with (nolock)
		join ProviderPractice pp with (nolock)
			on xref.provider_practice_id = pp.provider_practice_id

		left join provider_practice_management_system ppms with (nolock)
			on pp.provider_practice_management_system_id = ppms.provider_practice_managment_system_id

		left join @t t
			on pp.provider_practice_id = t.provider_practice_id
	where xref.pdts_provider_id = @pdts_provider_id
		and t.provider_practice_id is null
	order by pp.create_date 

	select *
	from @t;
END

