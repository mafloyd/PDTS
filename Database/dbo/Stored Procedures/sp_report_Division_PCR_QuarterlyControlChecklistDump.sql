

CREATE PROCEDURE [dbo].[sp_report_Division_PCR_QuarterlyControlChecklistDump]
	(
		@division_id INT,
		@quarter INT,
		@year INT,
		@prePost VARCHAR(4)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @isPre BIT;
	DECLARE @isPost BIT;

	IF UPPER(@prePost) = 'PRE'
		BEGIN
			SELECT @isPre = 1;
			SELECT @isPost = 0;
		END;
	ELSE IF UPPER(@prePost) = 'POST'
		BEGIN
			SELECT @isPre = 0;
			SELECT @isPost = 1;
		END;

    SELECT 
		a.coid, 
		a.QUARTER,
		a.year,
		f.name, 
		ma.control, 
		a.validate_user_name AS prepared_by, 
		a.validate_user_date AS prepared_date, 
		a.REVIEWED_USER_NAME AS reviewed_by, 
		a.REVIEWED_USER_DATE AS reviewed_date, 
		a.comment
	FROM dbo.FACILITY_QUARTERLY_AUDIT a WITH (NOLOCK)
		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.coid

		JOIN MASTER_AUDIT ma WITH (NOLOCK)
			ON a.audit_id = ma.audit_id
	WHERE a.QUARTER = @quarter
		AND a.year = @year
		AND a.pre = @isPre
		AND a.POST = @isPost
		AND f.DIVISION_ID = @division_id
	ORDER BY f.name
END



