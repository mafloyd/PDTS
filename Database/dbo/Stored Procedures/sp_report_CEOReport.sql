
CREATE PROCEDURE [dbo].[sp_report_CEOReport]
	(
	    @division_id int = 0,
	    @coid varchar(5) = null,
	    @user_id int,
	    @reportingPeriodMonth int,
	    @reportingPeriodYear int
	)
AS
BEGIN
	SET NOCOUNT ON;

    declare @admin bit
    declare @reportingPeriodDate datetime
    declare @origMonth int
    declare @origYear int
    
    select @origMonth = @reportingPeriodMonth;
    select @origYear = @reportingPeriodYear;
    
    if @reportingPeriodMonth < 11
		begin
			select @reportingPeriodMonth = @reportingPeriodMonth + 1
		end
	else if @reportingPeriodMonth = 12
		begin
			select @reportingPeriodMonth = 1
			select @reportingPeriodYear = @reportingPeriodYear + 1
		end
	
    select @reportingPeriodDate = cast(@reportingPeriodYear as char(4)) + '-' + cast(@reportingPeriodMonth as char(2)) + '-16'
	
    -- get admin status for strategy module
    select @admin = 0;
    
    select @admin = admin
    from user_module_xref
    where user_id = @user_id
        and module_id = 3
        
    declare @results table
		(
			coid VARCHAR(5),
			division_name varchar(50),
			facility_name varchar(50),
			category_id INT,
			strategy_name varchar(2000),
			strategy_category varchar(50),
			goal_type varchar(50),
			targeted_completion_date varchar(50),
			strategy_status_id int,
			action varchar(5000),
			service_line varchar(50),
			sub_strategy_id INT,
			sub_strategy varchar(2000),
			tactic varchar(2000),
			sub_strategy_action varchar(5000),
			volume_id int,
			project_owner varchar(100),
			sub_strategy_project_owner varchar(100)
		)
		
        if @division_id > 0
            begin
				insert into @results
					(
						coid,
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
						sub_strategy_id,
						sub_strategy,
						tactic,
						sub_strategy_action,
						volume_id,
						project_owner,
						sub_strategy_project_owner
					)
                select 
					f.coid,
                    d.name as division_name,
                    f.name as facility_name,
                    s.CATEGORY_ID,
                    s.name as strategy_name,
                    sc.name as strategy_category,
                    sgt.name as goal_type,
                    replace(s.targeted_completion_date, '12:00AM', ''),
                    s.strategy_status_id,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from StrategyActionUpdates with (nolock) 
						where strategy_id = s.strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as action,
                    isnull(spl.name, 'N/A') as service_line,
					ss.SUB_STRATEGY_ID,
                    ss.sub_strategy,
                    ss.tactic,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from SubStrategyActionUpdate with (nolock) 
						where sub_strategy_id = ss.sub_strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as sub_strategy_action,
					s.VOLUME_ID,
					s.project_owner,
					ss.project_owner
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
                where d.division_id = @division_id
					and s.category_id = 1
					and s.reporting_period_month = @origMonth
					and s.reporting_period_year = @origYear
					--and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
                order by d.name, f.name, sc.sort_order
                
				insert into @results
					(
						coid,
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
						sub_strategy_id,
						sub_strategy,
						tactic,
						sub_strategy_action,
						project_owner,
						sub_strategy_project_owner
					)
                SELECT
					f.coid,
                    d.name as division_name,
                    f.name as facility_name,
                    s.CATEGORY_ID,
                    s.name as strategy_name,
                    sc.name as strategy_category,
                    sgt.name as goal_type,
                    replace(s.targeted_completion_date, '12:00AM', ''),
                    s.strategy_status_id,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from StrategyActionUpdates with (nolock) 
						where strategy_id = s.strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as action,
                    isnull(spl.name, 'N/A') as service_line,
					ss.SUB_STRATEGY_ID,
                    ss.sub_strategy,
                    ss.tactic,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from SubStrategyActionUpdate with (nolock) 
						where sub_strategy_id = ss.sub_strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as sub_strategy_action,
					s.project_owner,
					ss.project_owner
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
							AND ss.STRATEGY_STATUS_ID = 1
                where d.division_id = @division_id
					and s.strategy_status_id = 1
					and s.category_id <> 1
					--and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
                order by d.name, f.name, sc.sort_order
            end
        else if isnull(@coid, 'X') <> 'X'
            begin
				insert into @results
					(
						coid,
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
						SUB_STRATEGY_ID,
						sub_strategy,
						tactic,
						sub_strategy_action,
						volume_id,
						project_owner,
						sub_strategy_project_owner
					)
                select 
					f.coid,
                    d.name as division_name,
                    f.name as facility_name,
                    s.CATEGORY_ID,
                    s.name as strategy_name,
                    sc.name as strategy_category,
                    sgt.name as goal_type,
                    replace(s.targeted_completion_date, '12:00AM', ''),
                    s.strategy_status_id,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from StrategyActionUpdates with (nolock) 
						where strategy_id = s.strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as action,
                    isnull(spl.name, 'N/A') as service_line,
					ss.SUB_STRATEGY_ID,
                    ss.sub_strategy,
                    ss.tactic,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from SubStrategyActionUpdate with (nolock) 
						where sub_strategy_id = ss.sub_strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as sub_strategy_action,
					s.VOLUME_ID,
					s.project_owner,
					ss.project_owner
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
                where s.coid = @coid
					and s.category_id = 1
					and s.reporting_period_month = @origMonth
					and s.reporting_period_year = @origYear
					--and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
                order by sc.sort_order
                
				insert into @results
					(
						coid,
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
						sub_strategy_id,
						sub_strategy,
						tactic,
						sub_strategy_action,
						project_owner,
						sub_strategy_project_owner
					)
                SELECT
					f.coid,
                    d.name as division_name,
                    f.name as facility_name,
                    s.category_id,
                    s.name as strategy_name,
                    sc.name as strategy_category,
                    sgt.name as goal_type,
                    replace(s.targeted_completion_date, '12:00AM', ''),
                    s.strategy_status_id,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from StrategyActionUpdates with (nolock) 
						where strategy_id = s.strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as action,
                    isnull(spl.name, 'N/A') as service_line,
					ss.SUB_STRATEGY_ID,
                    ss.sub_strategy,
                    ss.tactic,
                    (
						select top 1 convert(varchar(10), action_date, 101) + ':' + action 
						from SubStrategyActionUpdate with (nolock) 
						where sub_strategy_id = ss.sub_strategy_id 
							--and action_date < @reportingPeriodDate
							and deleted = 0
						order by action_date desc
					) as sub_strategy_action,
					s.project_owner,
					ss.project_owner
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
							AND ss.STRATEGY_STATUS_ID = 1
                where s.coid = @coid
					and s.strategy_status_id = 1
					and s.category_id <> 1
					--and (s.create_date < @reportingPeriodDate and isnull(s.update_date, @reportingPeriodDate) <= @reportingPeriodDate)
                order by sc.sort_order
            end
    
    IF @admin = 0
		BEGIN
			DELETE
			FROM @results
			WHERE category_id NOT IN (SELECT category_id FROM dbo.User_StrategyCategory_Xref WHERE user_id = @user_id);
		END;
	
	select *
	from @results;
END

