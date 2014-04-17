CREATE PROCEDURE [dbo].[sp_daily_employed_provider_status_update] 
AS
BEGIN
	SET NOCOUNT ON;

	-- first step is to activate any doc who is in the contract pending state and the start_date is now less than or equal to the current date
    update a
	set a.employed_provider_status_id = 1,
		update_date = getdate(),
		updated_by_user_id = 1685
	from Provider a with (nolock)
	join employed_provider_status b with (nolock)
		on a.employed_provider_status_id = b.employed_provider_status_id
	where a.employed = 1
		and a.start_date <= getdate()
		and a.left_date is null
		and a.employed_provider_status_id = 3
END

