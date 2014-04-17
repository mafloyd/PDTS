CREATE PROCEDURE [dbo].[sp_report_OpInits]
    (
      @coid VARCHAR(5) ,
      @reporting_period_month INT ,
      @reporting_period_year INT
	)
AS 
    BEGIN
        SET NOCOUNT ON;

        DECLARE @reporting_period DATETIME
        DECLARE @last_day_of_month INT
	
        IF @reporting_period_month IN ( 1, 3, 5, 7, 8, 10, 12 ) 
            BEGIN
                SELECT  @last_day_of_month = 31
            END
        ELSE 
            IF @reporting_period_month IN ( 4, 6, 9, 11 ) 
                BEGIN
                    SELECT  @last_day_of_month = 30
                END
            ELSE 
                BEGIN
                    SELECT  @last_day_of_month = 28
                END
		
        SELECT  @reporting_period = CAST(@reporting_period_year AS VARCHAR(4))
                + '-' + CAST(@reporting_period_month AS VARCHAR(2)) + '-'
                + CAST(@last_day_of_month AS VARCHAR(2));
	
        SELECT  a.operational_initiative_id ,
                b.name AS status ,
                a.initiative ,
                a.owner ,
                a.start_date ,
                a.estimated_completion_date ,
                a.projected_financial_impact ,
                c.name AS category ,
                d.monthly_amount ,
                d.reporting_period ,
                d.comment ,
                e.name AS facility
        FROM    OperationalInitiative a WITH ( NOLOCK )
                LEFT JOIN OperationalInitiativeStatus b WITH ( NOLOCK ) ON a.operational_initiative_status_id = b.operational_initiative_status_id
                LEFT JOIN OperationalCategory c WITH ( NOLOCK ) ON a.operational_category_id = c.operational_category_id
                LEFT JOIN OperationalInitiativeMonthlyEntry d WITH ( NOLOCK ) ON a.operational_initiative_id = d.operational_initiative_id
                                                              AND d.reporting_period_month = @reporting_period_month
                                                              AND d.reporting_period_year = @reporting_period_year
                JOIN Facility e WITH ( NOLOCK ) ON a.coid = e.coid
        WHERE   a.coid = @coid
        ORDER BY a.start_date ,
                a.estimated_completion_date
    -- Insert statements for procedure here
    END

