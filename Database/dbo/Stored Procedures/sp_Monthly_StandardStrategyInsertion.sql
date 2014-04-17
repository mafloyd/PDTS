  
CREATE PROCEDURE [dbo].[sp_Monthly_StandardStrategyInsertion]
AS
BEGIN
	declare @coid varchar(5)
	declare @reporting_period_year int
	declare @reporting_period_month int
	declare @current_date datetime
	declare @targeted_completion_date datetime
	declare @day int
	
	select @current_date = getdate();
	
	select @reporting_period_year = datepart(yyyy, @current_date);
	select @reporting_period_month = datepart(mm, @current_date);
		
	--select @reporting_period_year;
	--select @reporting_period_month;
	
	if @reporting_period_month in (1, 3, 5, 7, 8, 10, 12)
		begin
			select @targeted_completion_date = cast(@reporting_period_year as varchar(4)) + '-' + cast(@reporting_period_month as varchar(2)) + '-31';
		end
	else if @reporting_period_month = 2
		begin
			if dbo.ufn_IsLeapYear(@reporting_period_year) = 1
				begin
				select @targeted_completion_date = cast(@reporting_period_year as varchar(4)) + '-' + cast(@reporting_period_month as varchar(2)) + '-29';
				end
			else
				begin
					select @targeted_completion_date = cast(@reporting_period_year as varchar(4)) + '-' + cast(@reporting_period_month as varchar(2)) + '-28';
				end
		end
	else
		begin
			select @targeted_completion_date = cast(@reporting_period_year as varchar(4)) + '-' + cast(@reporting_period_month as varchar(2)) + '-30';
		end
	
	-- update all previous Standard Monthly Strategies to complete
	UPDATE strategy
	SET STRATEGY_STATUS_ID = 2
	WHERE category_id = 1
		AND ISNULL(VOLUME_ID, 0) > 0
		AND strategy_status_id = 1

	--select @targeted_completion_date;
				
	declare cur cursor fast_forward read_only for
	select coid
	from facility
	where active = 1
		and division_id is not null
		
	open cur
	
	fetch next from cur
	into @coid
	
	while @@fetch_status = 0
		begin
			insert into Strategy 
				(
					coid, 
					name, 
					category_id, 
					goal_type_id, 
					created_by_user_id, 
					targeted_completion_date,
					volume_id,
					reporting_period_year,
					reporting_period_month
				)
			select 
				@coid,
				volume_desc,
				1,
				1,
				483,
				@targeted_completion_date,
				a.volume_id,
				@reporting_period_year,
				@reporting_period_month
			from VolumeCommentType a with (nolock)
				left join Strategy b with (nolock)
					on a.volume_id = b.volume_id
						and b.coid = @coid
						and b.reporting_period_year = @reporting_period_year
						and b.reporting_period_month = @reporting_period_month
			where a.monthly_comment_required = 1
				and b.coid is null
				and b.reporting_period_year is null
				and b.reporting_period_month is null
				
			fetch next from cur
			into @coid
		end
		
close cur
deallocate cur
END

