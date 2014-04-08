
CREATE PROCEDURE [dbo].[sp_report_PCR_Division_MonthlyAccountChecklist]
	(
		@division_id INT,
		@month INT,
		@year INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @isPre BIT 
	DECLARE @isPost BIT
  
	SELECT @isPre = 0;
	SELECT @isPost = 1;
		   
	SELECT a.COID, a.sub_coid, f.name, a.ACCOUNT, a.VALIDATE_USER_NAME, a.VALIDATE_USER_DATE, a.REVIEWED_USER_NAME, a.REVIEWED_USER_DATE, a.COMMENT
	FROM dbo.PCR_HOSPITAL_MONTHLY_CHECKLIST a WITH (NOLOCK)
		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.coid
	WHERE a.month = @month
		AND a.year = @year
		AND a.IS_PRE = @isPre
		AND a.IS_POST = @isPost
		AND f.DIVISION_ID = @division_id
		AND f.pcr = 1;
END


