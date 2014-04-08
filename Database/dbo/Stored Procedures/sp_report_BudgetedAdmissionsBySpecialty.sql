
CREATE procedure [dbo].[sp_report_BudgetedAdmissionsBySpecialty]
(
    @coid varchar(5),
    @budgetYear int
)
as
begin
    select
        a.provider_id,
        a.last_name,
        a.first_name,
        s.long_name as specialty,
        cya.year,
        cya.monthno,
        cya.admits
    from provider a with (nolock)
        join specialty s
            on a.specialty_id = s.specialty_id
            
        join BudgetYear_Admit cya 
            on a.pdts_provider_id = cya.pdts_provider_id
                and cya.year = @budgetYear
                and cya.admits <> 0
    where a.coid = @coid
union
    select
        a.provider_id,
        a.last_name,
        a.first_name,
        s.long_name as specialty,
        cya.year,
        cya.monthno,
        cya.admits
    from provider a with (nolock)
        join specialty s with (nolock)
            on a.specialty_id = s.specialty_id
            
        join CurrentYear_Admit cya with (nolock)
            on a.pdts_provider_id = cya.pdts_provider_id
                and cya.year = (@budgetYear - 1)
                and cya.monthno < 9
                and cya.admits <> 0
    where a.coid = @coid
    order by 2, 3, 5, 6
end


