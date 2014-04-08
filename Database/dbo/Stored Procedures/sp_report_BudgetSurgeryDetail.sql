CREATE procedure [dbo].[sp_report_BudgetSurgeryDetail]
    (
        @coid varchar(5),
        @year int
    )
as    
begin
    set nocount on
  
    select 
        f.name as facility_name,
        p.provider_id,
        p.first_name,
        p.middle_name,
        p.last_name,
        p.dob,
        p.physician_group,
        p.start_date,
        p.left_date,
        s.long_name as specialty,
        pps.name as status,
        st.long_name as surgical_type,
        bys.monthno,
        bys.inpatient,
        bys.outpatient
    from provider p with (nolock)
        join Facility f with (nolock)
            on p.coid = f.coid
            
        join ProviderPositionStatus pps with (nolock)
            on p.provider_position_status_id = pps.provider_position_status_id
            
        left join Specialty s with (nolock)
            on p.specialty_id = s.specialty_id
            
        left join BudgetYear_Surgery bys with (nolock)
            on p.pdts_provider_id = bys.pdts_provider_id
                and bys.year = @year
                and (bys.inpatient > 0 or bys.outpatient > 0)
        
        join Surgical_Type st with (nolock)
            on bys.surgical_type_id = st.surgical_type_id
    where p.coid = @coid  
end

