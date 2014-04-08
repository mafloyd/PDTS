CREATE PROCEDURE [dbo].[sp_report_OpInits_Corporate]
	(
		@reporting_period_month INT,
		@reporting_period_year INT
	)
AS
BEGIN

	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF

	DECLARE @op TABLE
		(
			oid INT,
			oiname VARCHAR(50),
			oi_category INT,
			projected_fin_impact DECIMAL(19, 2),
			mtd_impact DECIMAL(19, 2)
		)
		
	INSERT INTO @op
			( 
				oid,
				oiname,
				oi_category,
				projected_fin_impact
			)
	SELECT oi.OPERATIONAL_INITIATIVE_ID, oc.NAME, oi.OPERATIONAL_CATEGORY_ID, oi.PROJECTED_FINANCIAL_IMPACT
	FROM dbo.OperationalInitiative oi WITH (NOLOCK)
		JOIN dbo.OperationalCategory oc WITH (NOLOCK)
			ON oi.OPERATIONAL_CATEGORY_ID = oc.OPERATIONAL_CATEGORY_ID
	WHERE DATEPART(yyyy, oi.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
	ORDER BY oc.name;
	
	DECLARE @oid INT
	
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT oid
	FROM @op
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @oid
	
	WHILE @@fetch_status = 0
		BEGIN
			UPDATE @op
			SET mtd_impact = 
				(
					SELECT SUM(ISNULL(MONTHLY_AMOUNT, 0))
					FROM dbo.OperationalInitiativeMonthlyEntry
					WHERE OPERATIONAL_INITIATIVE_ID = @oid
						AND REPORTING_PERIOD_MONTH <= @reporting_period_month
						AND REPORTING_PERIOD_YEAR = @reporting_period_year
				)
			WHERE oid = @oid;
			
			FETCH NEXT FROM cur
			INTO @oid	                
		END
		
	CLOSE cur
	DEALLOCATE cur

	SELECT 
		oc.NAME,
		ISNULL(a.projected_fin_impact, 0) AS projected_fin_impact,
		ISNULL(a.mtd_impact, 0) AS mtd_impact
	FROM @op a
		JOIN dbo.OperationalCategory oc
			ON a.oi_category = oc.OPERATIONAL_CATEGORY_ID
	ORDER BY oiname;
END;



