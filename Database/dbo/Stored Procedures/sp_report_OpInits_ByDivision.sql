
CREATE PROCEDURE [dbo].[sp_report_OpInits_ByDivision] 
	(
		@division_id int,
		@reporting_period_month int,
		@reporting_period_year int
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @op TABLE
	(
		operational_initiative_id INT,
		STATUS VARCHAR(50),
		initiative VARCHAR(2000),
		OWNER VARCHAR(50),
		start_date DATETIME,
		estimated_completion_date DATETIME,
		projected_financial_impact DECIMAL(19, 2),
		category_id INT,
		category VARCHAR(50),
		monthly_amount DECIMAL(19, 2),
		reporting_period_month INT,
		reporting_period_year INT,
		comment VARCHAR(2000),
		coid VARCHAR(5),
		facility VARCHAR(100),
		division_id INT,
		division VARCHAR(50),
		division_total_for_category DECIMAL(19, 2),
		grand_total_for_category DECIMAL(19, 2),
		hospital_total_for_category  DECIMAL(19, 2),
		grand_total DECIMAL(19, 2),
		division_grand_total DECIMAL(19, 2),
		total_projected_financial_impact_for_selected_divisions DECIMAL(19, 2)
	)

if @division_id > 1
	BEGIN
		INSERT INTO @op
		select
			a.operational_initiative_id,
			b.name as status,
			a.initiative,
			a.owner,
			a.start_date,
			a.estimated_completion_date,
			a.projected_financial_impact,
			c.OPERATIONAL_CATEGORY_ID,
			c.name as category,
			ISNULL(d.monthly_amount, 0) AS monthly_amount,
			d.REPORTING_PERIOD_MONTH,
			d.REPORTING_PERIOD_YEAR,
			d.comment,
			a.coid,
			e.name as facility,
			f.DIVISION_ID,
			f.name as division,
			0,
			0,
			0,
			0,
			0,
			0
		from OperationalInitiative a with (nolock)
			left join OperationalInitiativeStatus b with (nolock)
				on a.operational_initiative_status_id = b.operational_initiative_status_id
				
			left join OperationalCategory c with (nolock)
				on a.operational_category_id = c.operational_category_id
				
			left join OperationalInitiativeMonthlyEntry d with (nolock)
				on a.operational_initiative_id = d.operational_initiative_id
					and d.REPORTING_PERIOD_MONTH <= @reporting_period_month
					and d.REPORTING_PERIOD_YEAR = @reporting_period_year
				
			join Facility e with (nolock)
				on a.coid = e.coid
				
			join Division f with (nolock)
				on e.division_id = f.division_id
		where f.division_id = @division_id
			AND DATEPART(yyyy, a.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
		order by a.start_date, a.estimated_completion_date
		
		UPDATE a
		SET a.grand_total_for_category = (
											SELECT SUM(b.projected_financial_impact)
											FROM dbo.OperationalInitiative b WITH (NOLOCK)
												JOIN dbo.Facility f WITH (NOLOCK)
													ON b.coid = f.COID
											WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
												AND b.OPERATIONAL_CATEGORY_ID = a.category_id
												AND f.division_id = @division_id
										 )
		FROM @op a;
	end
else
	BEGIN
		INSERT INTO @op
		select
			a.operational_initiative_id,
			b.name as status,
			a.initiative,
			a.owner,
			a.start_date,
			a.estimated_completion_date,
			a.projected_financial_impact,
			c.OPERATIONAL_CATEGORY_ID,
			c.name as category,
			ISNULL(d.monthly_amount, 0) AS monthly_amount,
			d.REPORTING_PERIOD_MONTH,
			d.REPORTING_PERIOD_YEAR,
			d.comment,
			a.coid,
			e.name as facility,
			f.DIVISION_ID,
			f.name as division,
			0,
			0,
			0,
			0,
			0,
			0
		from OperationalInitiative a with (nolock)
			left join OperationalInitiativeStatus b with (nolock)
				on a.operational_initiative_status_id = b.operational_initiative_status_id
				
			left join OperationalCategory c with (nolock)
				on a.operational_category_id = c.operational_category_id
				
			left join OperationalInitiativeMonthlyEntry d with (nolock)
				on a.operational_initiative_id = d.operational_initiative_id
					AND d.REPORTING_PERIOD_MONTH <= @reporting_period_month
					AND d.REPORTING_PERIOD_YEAR = @reporting_period_year
				
			join Facility e with (nolock)
				on a.coid = e.coid
				
			join Division f with (nolock)
				on e.division_id = f.division_id
		WHERE DATEPART(yyyy, a.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
		order by a.start_date, a.estimated_completion_date
		
		UPDATE a
		SET a.grand_total_for_category = (
											SELECT SUM(b.projected_financial_impact)
											FROM dbo.OperationalInitiative b WITH (NOLOCK)
											WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
												AND b.OPERATIONAL_CATEGORY_ID = a.category_id
										 )
		FROM @op a;
	END
	
	UPDATE a
	SET a.division_total_for_category = (
											SELECT SUM(b.projected_financial_impact)
											FROM dbo.OperationalInitiative b WITH (NOLOCK)
												JOIN dbo.Facility f WITH (NOLOCK)
													ON b.coid = f.coid
											WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
												AND f.DIVISION_ID = a.division_id
												AND b.OPERATIONAL_CATEGORY_ID = a.category_id
										  )
	FROM @op a;
												
	UPDATE a
	SET a.hospital_total_for_category = (
											SELECT SUM(b.projected_financial_impact)
											FROM dbo.OperationalInitiative b WITH (NOLOCK)
											WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
												AND b.coid = a.coid
												AND b.OPERATIONAL_CATEGORY_ID = a.category_id
										)
	FROM @op a;
	
	UPDATE a
	SET a.grand_total = (
							SELECT SUM(b.projected_financial_impact)
							FROM dbo.OperationalInitiative b WITH (NOLOCK)
							WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
						)
	FROM @op a;
	
	UPDATE a
	SET a.division_grand_total = (
									SELECT SUM(b.projected_financial_impact)
									FROM dbo.OperationalInitiative b WITH (NOLOCK)
										JOIN dbo.Facility f WITH (NOLOCK)
											ON b.coid = f.coid
									WHERE DATEPART(yyyy, b.ESTIMATED_COMPLETION_DATE) = @reporting_period_year
										AND f.DIVISION_ID = a.division_id
								 )
	FROM @op a;
	
	IF @division_id > 1
		BEGIN
			UPDATE @op
			SET total_projected_financial_impact_for_selected_divisions = division_grand_total;
		END;
	ELSE
		begin
			UPDATE @op
			SET total_projected_financial_impact_for_selected_divisions = grand_total;
		END;
		
	SELECT *
	FROM @op;
END


