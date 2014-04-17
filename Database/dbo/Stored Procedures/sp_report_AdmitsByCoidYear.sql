CREATE procedure [dbo].[sp_report_AdmitsByCoidYear]
    (
        @coid varchar(5),
        @year int,
        @division_id int = null
    )
as
begin
    if @division_id is null 
        begin
            select p.pdts_provider_id, p.provider_id, b.monthno, b.admits
            from provider p with (nolock)
                join CurrentYear_Admit b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where p.coid = @coid
                and b.year = @year
                and b.admits <> 0
            order by p.provider_id
        end
    else
        begin
            select p.pdts_provider_id, p.provider_id, b.monthno, b.admits
            from facility f with (nolock)
                join provider p with (nolock)
                    on f.coid = p.coid
                    
                join CurrentYear_Admit b with (nolock)
                    on p.pdts_provider_id = b.pdts_provider_id
            where f.division_id = @division_id
                and b.year = @year
                and b.admits <> 0
            order by p.provider_id
        end
end

