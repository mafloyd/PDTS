
CREATE PROCEDURE [dbo].[sp_report_PCR_QuarterlyAccountChecklist]
	(
		@coid VARCHAR(5),
		@quarter INT,
		@year INT,
		@otherCoids BIT = 0,
		@prePost VARCHAR(4)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @isPre BIT 
	DECLARE @isPost BIT
  
	SELECT @isPre = 0;
	SELECT @isPost = 0;

	IF UPPER(@prePost) = 'PRE'  
		BEGIN
			SET @isPre = 1;
			SET @isPost = 0;      
		END;   
	ELSE IF UPPER(@prePost) = 'POST'
		BEGIN
			SET @isPre = 0;
			SET @isPost = 1;      
		END;
		   
	IF @otherCoids = 0
		begin
			SELECT a.COID, a.sub_coid, f.name, a.SUB_COID, a.ACCOUNT, a.VALIDATE_USER_NAME, a.VALIDATE_USER_DATE, a.REVIEWED_USER_NAME, a.REVIEWED_USER_DATE, a.COMMENT
			FROM dbo.PCR_HOSPITAL_QUARTERLY_CHECKLIST a WITH (NOLOCK)
				JOIN Facility f WITH (NOLOCK)
					ON a.coid = f.coid
			WHERE a.coid = @coid
				AND a.SUB_COID = @coid
				AND a.QUARTER = @quarter
				AND a.year = @year
				AND a.IS_PRE = @isPre
				AND a.IS_POST = @isPost
			ORDER BY a.coid, a.SUB_COID, a.ACCOUNT
		END;
	ELSE IF @otherCoids = 1
		BEGIN
			SELECT a.COID, a.sub_coid, f.name, a.SUB_COID, a.ACCOUNT, a.VALIDATE_USER_NAME, a.VALIDATE_USER_DATE, a.REVIEWED_USER_NAME, a.REVIEWED_USER_DATE, a.COMMENT
			FROM dbo.PCR_HOSPITAL_QUARTERLY_CHECKLIST a WITH (NOLOCK)
				JOIN Facility f WITH (NOLOCK)
					ON a.COID = f.coid
			WHERE a.coid = @coid
				AND a.SUB_COID != @coid
				AND a.QUARTER = @quarter
				AND a.year = @year
				AND a.IS_PRE = @isPre
				AND a.IS_POST = @isPost
			ORDER BY a.coid, a.SUB_COID, a.ACCOUNT;
		END;      
END


