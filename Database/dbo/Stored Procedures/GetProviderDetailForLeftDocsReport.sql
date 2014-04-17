-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProviderDetailForLeftDocsReport]
	(
		@coid varchar(5),
		@provider_id int
	)
AS
BEGIN
	SET NOCOUNT ON;

    select 
		p.coid, 
		f.name, 
		p.provider_id, 
		p.first_name, 
		p.middle_name, 
		p.last_name, 
		s.long_name as specialty,
		pps.name as status,
		case isnull(p.physician_reason_id, 0)
			when 0 then null
			when 8 then p.other_reason_text
			else pr.long_name
		end as reason,
		p.left_date,
		d.name as division
	from provider p with (nolock)
		join facility f with (nolock)
			on p.coid = f.coid
			
		join Division d with (nolock)
			on f.division_id = d.division_id
			
		left join Specialty s with (nolock)
			on p.specialty_id = s.specialty_id
			
		left join ProviderPositionStatus pps with (nolock)
			on p.provider_position_status_id = pps.provider_position_status_id
			
		left join Physician_Reason pr with (nolock)
			on p.physician_reason_id = pr.physician_reason_id
	where p.coid = @coid
		and p.provider_id = @provider_id
END

