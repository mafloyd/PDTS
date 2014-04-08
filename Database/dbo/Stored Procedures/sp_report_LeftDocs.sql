CREATE PROCEDURE [dbo].[sp_report_LeftDocs]
	(
	    @coid varchar(5) = null,
	    @revenueDate datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

    if @coid is null
        begin
            select 
                p.coid,
                f.name as facility_name,
                p.provider_id,
                isnull(p.last_name, '') + ', ' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
                s.long_name as specialty,
                pr.long_name as reason_leaving,
                p.other_reason_text,
                p.left_date,
                pps.name as status
            from provider p with (nolock)
                join facility f with (nolock)
                    on p.coid = f.coid
                    
                left join specialty s
                    on p.specialty_id = s.specialty_id
                    
                left join Physician_Reason pr
                    on p.physician_reason_id = pr.physician_reason_id
                    
                left join ProviderPositionStatus pps
                    on p.provider_position_status_id = pps.provider_position_status_id
            where p.left_date is not null
                and (p.left_date <= @revenueDate)
            order by f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
        end
    else
        begin
            select 
                p.coid,
                f.name as facility_name,
                p.provider_id,
                isnull(p.last_name, '') + ', ' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '') as provider_name,
                s.long_name as specialty,
                pr.long_name as reason_leaving,
                p.other_reason_text,
                p.left_date,
                pps.name as status
            from provider p with (nolock)
                join facility f with (nolock)
                    on p.coid = f.coid
                    
                left join specialty s
                    on p.specialty_id = s.specialty_id
                    
                left join Physician_Reason pr
                    on p.physician_reason_id = pr.physician_reason_id
                    
                left join ProviderPositionStatus pps
                    on p.provider_position_status_id = pps.provider_position_status_id
            where p.coid = @coid
                and p.left_date is not null
                and (p.left_date <= @revenueDate)
            order by f.name, isnull(p.last_name, '') + ',' + isnull(p.first_name, '') + ' ' + isnull(p.middle_name, '')
        end;
END

