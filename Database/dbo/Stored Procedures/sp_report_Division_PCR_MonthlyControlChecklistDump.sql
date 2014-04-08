
CREATE PROCEDURE [dbo].[sp_report_Division_PCR_MonthlyControlChecklistDump]
	(
		@division_id INT,
		@month INT,
		@year int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		a.coid, 
		a.month,
		a.year,
		f.name, 
		ma.control, 
		a.validate_user_name AS prepared_by, 
		a.validate_user_date AS prepared_date, 
		a.REVIEWED_USER_NAME AS reviewed_by, 
		a.REVIEWED_USER_DATE AS reviewed_date, 
		a.comment
	FROM dbo.FACILITY_MONTHLY_AUDIT a WITH (NOLOCK)
		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.coid

		JOIN MASTER_AUDIT ma WITH (NOLOCK)
			ON a.audit_id = ma.audit_id
	WHERE a.month = @month
		AND a.year = @year
		AND f.DIVISION_ID = @division_id
	ORDER BY f.name
END


