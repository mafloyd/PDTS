CREATE PROCEDURE [dbo].[sp_Monthly_CreateERStats]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @coid varchar(5)
	declare @month int
	declare @year int

	select @month = datepart(mm, getdate());
	select @year = datepart(yyyy, getdate());

	declare cur cursor fast_forward read_only for
	select distinct coid
	from er_daily_entry;

	open cur

	fetch next from cur
	into @coid

	while @@fetch_status = 0
		begin
			insert into er_daily_entry 
				(
					er_daily_stats_definition_id,
					coid,
					year,
					month,
					created_by_user_id
				)
			select a.er_daily_stats_definition_id,
				@coid,
				@year,
				@month,
				483
			from er_daily_stats_definition a
				left join er_daily_entry b
					on b.coid = @coid
						and b.er_daily_stats_definition_id = a.er_daily_stats_definition_id
						and b.year = @year
						and b.month = @month
			where isnull(a.coid, @coid) = @coid
				and a.active_for_ui = 1
				and b.coid is null

			fetch next from cur
			into @coid;
		end;

	close cur;
	deallocate cur;
END

