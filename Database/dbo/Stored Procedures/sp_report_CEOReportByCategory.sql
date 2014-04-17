CREATE PROCEDURE [dbo].[sp_report_CEOReportByCategory]
	(
	    @division_id INT = 0,
	    @user_id int,
	    @category_id INT = 0,
	    @reportingPeriodMonth int,
	    @reportingPeriodYear int
	)
AS
BEGIN
	SET NOCOUNT ON;

    declare @admin bit
    declare @reportingPeriodDate DATETIME
    DECLARE @origMonth INT
    DECLARE @origYear INT
    
    SELECT @origMonth = @reportingPeriodMonth
    SELECT @origYear = @reportingPeriodYear
    
    IF @reportingPeriodMonth < 11
		BEGIN
			SELECT @reportingPeriodMonth = @reportingPeriodMonth + 1;
		END;
	ELSE IF @reportingPeriodMonth = 12
		BEGIN
			SELECT @reportingPeriodMonth = 1;
			SELECT @reportingPeriodYear = @reportingPeriodYear + 1;
		END;
		
    select @reportingPeriodDate = cast(@reportingPeriodYear as char(4)) + '-' + cast(@reportingPeriodMonth as char(2)) + '-16'
    
    -- get admin status for strategy module
    select @admin = 0;
    
    select @admin = admin
    from user_module_xref
    where user_id = @user_id
        and module_id = 3
               
	DECLARE @results TABLE
		(
			coid VARCHAR(5),
			division_id INT,
			division_name VARCHAR(50),
			facility_name VARCHAR(50),
			category_id INT,
			strategy_name VARCHAR(2000),
			strategy_category VARCHAR(50),
			goal_type VARCHAR(50),
			targeted_completion_date DATETIME,
			strategy_status_id INT,
			ACTION VARCHAR(5000),
			service_line VARCHAR(50),
			sub_strategy VARCHAR(5000),
			tactic VARCHAR(2000),
			sub_strategy_action VARCHAR(5000),
			volume_id int
		)
	
	insert into @results
		(
			coid,
			division_id,
			division_name,
			facility_name,
			category_id,
			strategy_name,
			strategy_category,
			goal_type,
			targeted_completion_date,
			strategy_status_id,
			action,
			service_line,
			sub_strategy,
			tactic,
			sub_strategy_action,
			volume_id
		)
    select 
		f.coid,
		d.division_id,
        d.name as division_name,
        f.name as facility_name,
        s.CATEGORY_ID,
        s.name as strategy_name,
        sc.name as strategy_category,
        sgt.name as goal_type,
        s.targeted_completion_date,
        s.strategy_status_id,
        (
			select top 1 convert(varchar(10), action_date, 101) + ':' + action 
			from StrategyActionUpdates with (nolock) 
			where strategy_id = s.strategy_id 
				and action_date < @reportingPeriodDate
				and deleted = 0
			order by action_date desc
		) as action,
        isnull(spl.name, 'N/A') as service_line,
        ss.sub_strategy,
        ss.tactic,
        (
			select top 1 convert(varchar(10), action_date, 101) + ':' + action 
			from SubStrategyActionUpdate with (nolock) 
			where sub_strategy_id = ss.sub_strategy_id 
				and action_date < @reportingPeriodDate
				and deleted = 0
			order by action_date desc
		) as sub_strategy_action,
		s.VOLUME_ID
    from Division d with (nolock)
        join Facility f with (nolock)
            on d.division_id = f.division_id
            
        join Strategy s with (nolock)
            on f.coid = s.coid
            
        join StrategyCategory sc with (nolock)
            on s.category_id = sc.category_id
            
        join StrategyGoalType sgt with (nolock)
            on s.goal_type_id = sgt.goal_type_id
                
        left join StrategyProductLine spl with (nolock)
			on s.product_line_id = spl.product_line_id
			
		left join SubStrategy ss with (nolock)
			on s.strategy_id = ss.strategy_id
    where s.category_id = 1
		and s.reporting_period_month = @origMonth
		and s.reporting_period_year = @origYear
		and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
    order by d.name, f.name, sc.sort_order
    
    insert into @results
		(
			coid,
			division_id,
			division_name,
			facility_name,
			category_id,
			strategy_name,
			strategy_category,
			goal_type,
			targeted_completion_date,
			strategy_status_id,
			action,
			service_line,
			sub_strategy,
			tactic,
			sub_strategy_action,
			volume_id
		)
    select 
		f.coid,
		d.division_id,
        d.name as division_name,
        f.name as facility_name,
        s.CATEGORY_ID,
        s.name as strategy_name,
        sc.name as strategy_category,
        sgt.name as goal_type,
        s.targeted_completion_date,
        s.strategy_status_id,
        (
			select top 1 convert(varchar(10), action_date, 101) + ':' + action 
			from StrategyActionUpdates with (nolock) 
			where strategy_id = s.strategy_id 
				and action_date < @reportingPeriodDate
				and deleted = 0
			order by action_date desc
		) as action,
        isnull(spl.name, 'N/A') as service_line,
        ss.sub_strategy,
        ss.tactic,
        (
			select top 1 convert(varchar(10), action_date, 101) + ':' + action 
			from SubStrategyActionUpdate with (nolock) 
			where sub_strategy_id = ss.sub_strategy_id 
				and action_date < @reportingPeriodDate
				and deleted = 0
			order by action_date desc
		) as sub_strategy_action,
		s.VOLUME_ID
    from Division d with (nolock)
        join Facility f with (nolock)
            on d.division_id = f.division_id
            
        join Strategy s with (nolock)
            on f.coid = s.coid
            
        join StrategyCategory sc with (nolock)
            on s.category_id = sc.category_id
            
        join StrategyGoalType sgt with (nolock)
            on s.goal_type_id = sgt.goal_type_id
                
        left join StrategyProductLine spl with (nolock)
			on s.product_line_id = spl.product_line_id
			
		left join SubStrategy ss with (nolock)
			on s.strategy_id = ss.strategy_id
    where s.category_id <> 1
		and s.strategy_status_id = 1
		and s.category_id <> 1
		and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
    order by d.name, f.name, sc.sort_order
    
    IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id;
		END;
	
	IF @category_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE category_id <> @category_id;
		END;
		
	SELECT *
	FROM @results;
END

