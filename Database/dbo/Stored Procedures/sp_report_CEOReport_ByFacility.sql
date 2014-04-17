CREATE PROCEDURE [dbo].[sp_report_CEOReport_ByFacility]
	(
	    @coid varchar(5),
	    @user_id int
	)
AS
BEGIN
	SET NOCOUNT ON;

    declare @admin bit
    
    -- get admin status for strategy module
    select @admin = 0;
    
    select @admin = admin
    from user_module_xref
    where user_id = @user_id
        and module_id = 3
        
    if @admin = 1
        begin
            select 
                s.name as strategy_name,
                sc.name as strategy_category,
                sgt.name as goal_type,
                s.targeted_completion_date,
                (select top 1 action from StrategyActionUpdates with (nolock) where strategy_id = s.strategy_id and deleted = 0 order by create_date desc) as action
            from Strategy s with (nolock)
                join StrategyCategory sc with (nolock)
                    on s.category_id = sc.category_id
                    
                join StrategyGoalType sgt with (nolock)
                    on s.goal_type_id = sgt.goal_type_id
            where s.coid = @coid
				and strategy_status_id = 1
            order by sc.sort_order
        end
    else
        begin
            select 
                s.name as strategy_name,
                sc.name as strategy_category,
                sgt.name as goal_type,
                s.targeted_completion_date,
                (select top 1 action from StrategyActionUpdates with (nolock) where strategy_id = s.strategy_id and deleted = 0 order by create_date desc) as action
            from Strategy s with (nolock)
                join StrategyCategory sc with (nolock)
                    on s.category_id = sc.category_id
                    
                join StrategyGoalType sgt with (nolock)
                    on s.goal_type_id = sgt.goal_type_id
                    
                join User_StrategyCategory_Xref xref with (nolock)
                    on s.category_id = xref.category_id
                        and xref.user_id = @user_id
                        and xref.active = 1
            where s.coid = @coid
				and s.strategy_status_id = 1
                    order by sc.sort_order
        end
END

