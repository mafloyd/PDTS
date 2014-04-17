CREATE PROCEDURE [dbo].[sp_PCR_MonthlyControlChecklist]
	(
		@coid VARCHAR(5),
		@month INT,
		@year INT
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT f.NAME AS facility, ma.CONTROL_ID, ma.control, fma.VALIDATE_USER_NAME, fma.VALIDATE_USER_DATE, fma.REVIEWED_USER_NAME, fma.REVIEWED_USER_DATE, fma.COMMENT
	FROM Facility f WITH (NOLOCK)
	JOIN dbo.FACILITY_MONTHLY_AUDIT fma WITH (NOLOCK)
		ON f.COID = fma.COID

	JOIN dbo.MASTER_AUDIT ma WITH (NOLOCK)
		ON fma.AUDIT_ID = ma.AUDIT_ID
	WHERE f.coid = @coid
		AND fma.month = @month
		AND fma.year = @year
	ORDER BY ma.CONTROL_ID
END

