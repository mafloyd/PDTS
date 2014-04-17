
CREATE PROCEDURE [dbo].[sp_report_PCR_Division_QuarterlyAccountChecklist]
	(
		@division_id INT,
		@quarter INT,
		@year INT,
		@prePost VARCHAR(4)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @isPre BIT 
	DECLARE @isPost BIT
  
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
		   
	SELECT a.COID, a.sub_coid, f.name, a.ACCOUNT, a.VALIDATE_USER_NAME, a.VALIDATE_USER_DATE, a.REVIEWED_USER_NAME, a.REVIEWED_USER_DATE, a.COMMENT
	FROM dbo.PCR_HOSPITAL_QUARTERLY_CHECKLIST a WITH (NOLOCK)
		JOIN Facility f WITH (NOLOCK)
			ON a.coid = f.coid
	WHERE a.quarter = @quarter
		AND a.YEAR = @year
		AND a.IS_PRE = @isPre
		AND a.IS_POST = @isPost
		AND f.DIVISION_ID = @division_id
		AND f.pcr = 1;
END

