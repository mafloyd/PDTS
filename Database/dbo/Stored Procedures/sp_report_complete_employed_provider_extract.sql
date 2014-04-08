CREATE PROCEDURE [dbo].[sp_report_complete_employed_provider_extract]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT distinct
		p.coid, 
		p.provider_id, 
		p.npi, 
		f.name as facility, 
		p.last_name, 
		p.first_name, 
		p.middle_name, 
		p.dob,
		s.long_name AS specialty,
		pct.NAME AS agreement_type,
		pa.name AS msd_status,
		pps.name AS position_status,
		p.start_date,
		p.left_date,
		p.EMAIL_ADDRESS,
		p.EMPLOYEE_PHYSICIAN_COID, 
		p.employed,
		pd.dept_number AS provider_department,
		pod.dept_number as clinic_overhead_dept,
		d.name AS division,
		user1.FIRST_NAME + ' ' + user1.LAST_NAME AS senior_director,
		user2.FIRST_NAME + ' ' + user2.LAST_NAME AS director,
		p.src_id,
		pss.name AS phys_status,
		p.SUM_NUMBER,
		p.provider_count,
		p.ACTIVE,
		p.dea_number,
		p.email_address,
		pt.name as title,
		p.nppes_login,
		p.nppes_password,
		p.group_npi,
		p.ssn,
		provt.name as type,
		p.fte_assessment,
		eps.name as employed_provider_status,
		(select top 1 contract_length from ProviderContract where pdts_provider_id = p.pdts_provider_id) as contract_length,
		(select top 1 contractual_term_date from ProviderContract where pdts_provider_id = p.pdts_provider_id) as contract_expiration,
		(select top 1 salary from ProviderContract where pdts_provider_id = p.pdts_provider_id) as salary,
		p.joining_an_existing_practice,
		p.replacing_an_existing_provider,
		p.provider_being_replaced,
		p.prior_malpractice_coverage_amount,
		p.prior_malpractice_coverage_carrier,
		p.budgeted,
		plob.name as line_of_business,
		pb.name as bill_type,
		(select top 1 pp.dba_name from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as practice_name1,
		(select top 1 pp.office_manager_first_name from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as practice_office_manager_first_name1,
		(select top 1 pp.office_manager_last_name from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as practice_office_manager_last_name1,
		prd.first_name as regional_director_first_name,
		prd.last_name as regional_director_last_name,
		(select top 1 pp.legal_entity from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as practice_legal_entity1,
		(select top 1 pp.tax_id from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as practice_tax_id1,
		(
			select top 1 ppms.name 
			from ProviderPracticeXref xref with (nolock)
				join ProviderPractice pp 
					on xref.provider_practice_id = pp.provider_practice_id
					

				left join PROVIDER_PRACTICE_MANAGEMENT_SYSTEM ppms with (nolock)
					on pp.provider_practice_management_system_id = ppms.provider_practice_managment_system_id
			where xref.pdts_provider_id = p.pdts_provider_id
			order by pp.dba_name
		) as provider_practice_management_system1,
		(select top 1 pp.pm_projected_implementation_date from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as implementation_date1,
		(select top 1 pp.payroll_system from ProviderPracticeXref xref join ProviderPractice pp on xref.provider_practice_id = pp.provider_practice_id where xref.pdts_provider_id = p.pdts_provider_id order by pp.dba_name) as payroll_system1
	FROM Provider p WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON p.coid = f.coid

		LEFT JOIN dbo.Specialty s WITH (NOLOCK)
			ON p.SPECIALTY_ID = s.SPECIALTY_ID

		LEFT JOIN dbo.ProviderContractType pct WITH (NOLOCK)
			ON p.PROVIDER_CONTRACT_TYPE_ID = pct.PROVIDER_CONTRACT_TYPE_ID

		LEFT JOIN dbo.PROVIDER_AFFILIATION pa WITH (NOLOCK)
			ON p.PROVIDER_AFFILIATION_ID = pa.PROVIDER_AFFILIATION_ID

		LEFT JOIN dbo.ProviderPositionStatus pps WITH (NOLOCK)
			ON p.PROVIDER_POSITION_STATUS_ID = pps.PROVIDER_POSITION_STATUS_ID

		LEFT JOIN dbo.ProviderDepartment pd with (NOLOCK)
			on p.PROVIDER_DEPT_ID = pd.PROVIDER_DEPT_ID

		join dbo.Division d with (NOLOCK)
			ON f.division_id = d.DIVISION_ID

		LEFT JOIN dbo.ProviderSeniorDirector psd with (NOLOCK)
			ON p.PROVIDER_SENIOR_DIRECTOR_ID = psd.PROVIDER_SENIOR_DIRECTOR_ID

		left join PdtsUser user1
			on psd.user_id = user1.user_id

		LEFT JOIN dbo.PROVIDER_DIRECTOR pdir with (NOLOCK)
			on p.PROVIDER_DIRECTOR_ID = pdir.PROVIDER_DIRECTOR_ID

		left join PdtsUser user2
			on pdir.user_id = user2.user_id

		LEFT join dbo.PROVIDER_STAFF_STATUS pss WITH (NOLOCK)
			on p.PROVIDER_STAFF_STATUS_ID = pss.PROVIDER_STAFF_STATUS_ID

		left join ProviderTitle pt with (nolock)
			on p.provider_title_id = pt.provider_title_id

		left join ProviderOverheadDepartment pod with (nolock)
			on p.provider_overhead_dept_id = pod.provider_overhead_dept_id

		left join provider_type provt with (nolock)
			on p.provider_type_id = provt.provider_type_id

		left join employed_provider_status eps with (nolock)
			on p.employed_provider_status_id = eps.employed_provider_status_id

		left join provider_line_of_business plob with (nolock)
			on p.provider_line_of_business_id = plob.provider_line_of_business_id

		left join provider_bill_type pb with (nolock)
			on p.provider_bill_type_id = pb.provider_bill_type_id

		left join ProviderRegionalDirector prd with (nolock)
			on p.provider_regional_director_id = prd.provider_regional_director_id
	WHERE p.employed = 1
		and p.employed_provider_status_id is not null
	ORDER BY f.NAME, p.last_name, p.first_name, p.middle_name

END

