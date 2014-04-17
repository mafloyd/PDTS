CREATE PROCEDURE [dbo].[sp_report_PCR_QuarteryControlChecklist]
	(
		@coid VARCHAR(5),
		@quarter INT,
		@year INT,
		@prePost VARCHAR(4)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @pre BIT;
	DECLARE @post BIT;

	IF UPPER(@prePost) = 'PRE'
		BEGIN
			SELECT @pre = 1;
			SELECT @post = 0;      
		END;      
	ELSE IF UPPER(@prePost) = 'POST'
		BEGIN
			SELECT @pre = 0;
			SELECT @post = 1;      
		END;      

    SELECT f.NAME AS facility, ma.CONTROL_ID, ma.control, fqa.VALIDATE_USER_NAME, fqa.VALIDATE_USER_DATE, fqa.REVIEWED_USER_NAME, fqa.REVIEWED_USER_DATE, fqa.COMMENT
	FROM Facility f WITH (NOLOCK)
	JOIN dbo.FACILITY_QUARTERLY_AUDIT fqa WITH (NOLOCK)
		ON f.COID = fqa.COID

	JOIN dbo.MASTER_AUDIT ma WITH (NOLOCK)
		ON fqa.AUDIT_ID = ma.AUDIT_ID
	WHERE f.coid = @coid
		AND fqa.quarter = @quarter
		AND fqa.year = @year
		AND fqa.PRE = @pre
		AND fqa.POST = @post
	ORDER BY ma.CONTROL_ID
END

