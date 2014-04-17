CREATE procedure [dbo].[sp_report_ProjectedAdmissionsBySpecialty]
(
    @coid varchar(5),
    @year int
)
as
begin
    select
        a.provider_id,
        a.last_name,
        a.first_name,
        s.long_name as specialty,
        proj.year,
        proj.period9_admits,
        proj.period10_admits,
        proj.period11_admits,
        proj.period12_admits
    from provider a with (nolock)
        join specialty s
            on a.specialty_id = s.specialty_id
            
        join ProjectedAdmits proj
            on a.pdts_provider_id = proj.pdts_provider_id
                and proj.year >= @year - 1
    where a.coid = @coid
end

