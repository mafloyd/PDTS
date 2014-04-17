CREATE PROCEDURE [dbo].[sp_report_EmployedProviderChanges]
	(
		@beginDate datetime,
		@endDate datetime
	)
AS
BEGIN
	SET NOCOUNT ON;

    select 
		a.friendly_column_name, 
		a.old_value_display, 
		a.new_value_display, 
		a.create_date,
		b.full_name as end_user,
		f.name as hospital,
		isnull(p.last_name, '') as last_name,
		isnull(p.first_name, '') as first_name, 
		isnull(p.middle_name, '') as middle_name,
		p.provider_id
	from pending_change a with (nolock)
		join PdtsUser b with (nolock)
			on a.created_by_user_id = b.user_id

		join Provider p with (nolock)
			on a.primary_key_value = p.pdts_provider_id

		join Facility f with (nolock)
			on p.coid = f.coid
	where a.create_date between @beginDate and @endDate
	order by f.name, p.last_name, p.first_name, p.middle_name, a.create_date;
END

