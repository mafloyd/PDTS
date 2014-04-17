CREATE PROCEDURE [dbo].[sp_report_PI_ApprovedStatusReport]
	(
		@coid varchar(5)
	)
AS
BEGIN
	SET NOCOUNT ON;

	select f.name as facility, 
		pit.name as team_name,
		pii.performance_improvement_idea_id,
		piis.name as idea_status,
		pics.name as completion_status,
		pii.idea,
		pipq.name as payoff_quadrant,
		pii.total_projected_savings,
		pii.estimated_completion_date,
		pii.actual_completion_date,
		pii.recommended_imp_leader
	from performance_improvement_idea pii with (nolock)
		join facility f with (nolock)
			on pii.coid = f.coid

		left join performance_improvement_team pit with (nolock)
			on pii.performance_improvement_team_id = pit.performance_improvement_team_id

		left join performance_improvement_idea_status piis with (nolock)
			on pii.performance_improvement_idea_status_id = piis.perfomance_improvement_idea_status_id 

		left join performance_improvement_completion_status pics with (nolock)
			on pii.performance_improvement_completion_status_id = pics.performance_improvement_completion_status_id

		left join performance_improvement_payoff_quadrant pipq with (nolock)
			on pii.performance_improvement_payoff_quadrant_id = pipq.performance_improvement_payoff_quadrant_id
	where pii.performance_improvement_idea_status_id = 4;
END

