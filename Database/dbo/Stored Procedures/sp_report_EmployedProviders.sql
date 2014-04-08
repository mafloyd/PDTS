CREATE PROCEDURE [dbo].[sp_report_EmployedProviders]
	(
		@coid varchar(5)
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	select 
		f.name as facility,
		p.first_name, 
		p.last_name, 
		p.start_date,
		p.left_date,
		p.npi,
		p.group_npi,
		p.dea_number,
		p.employee_physician_coid,
		pd.dept_number,
		pt.name as provider_type,
		p.fte_assessment,
		epp.name as employed_provider_status,
		pp.dba_name,
		ppa.address1,
		ppa.city,
		st.short_name as state,
		ppa.zip_code,
		pp.legal_entity,
		pp.tax_id
	from Provider p with (nolock)
		left join ProviderDepartment pd with (nolock)
			on p.provider_dept_id = pd.provider_dept_id

		left join provider_type pt with (nolock)
			on p.provider_type_id = pt.provider_type_id

		left join employed_provider_status epp with (nolock)
			on p.employed_provider_status_id = epp.employed_provider_status_id

		left join provider_line_of_business plob with (nolock)
			on p.provider_line_of_business_id = plob.provider_line_of_business_id

		left join provider_bill_type pbt with (nolock)
			on p.provider_bill_type_id = pbt.provider_bill_type_id

		left join ProviderPracticeXref xref with (nolock)
			on p.pdts_provider_id = xref.pdts_provider_id
				and xref.active = 1

		left join ProviderPractice pp with (nolock)
			on xref.provider_practice_id = pp.provider_practice_id

		left join provider_practice_address_xref axref with (nolock)
			on pp.provider_practice_id = axref.provider_practice_id

		left join ProviderPracticeAddress ppa with (nolock)
			on axref.provider_practice_address_id = ppa.provider_practice_address_id

		left join State st with (nolock)
			on ppa.state_id = st.state_id

		join facility f with (nolock)
			on p.coid = f.coid
	where p.coid = @coid
		and employed = 1
	order by p.last_name, p.first_name
END

