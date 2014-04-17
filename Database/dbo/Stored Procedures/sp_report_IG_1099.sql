CREATE PROCEDURE [dbo].[sp_report_IG_1099]
	(
		@pdts_provider_id INT,
		@tax_year INT,
		@first_year BIT = 0
	)
AS
BEGIN
	DECLARE @min_year INT;
	
	SELECT @min_year = DATEPART(yyyy, START_DATE)
	FROM dbo.ig_Worksheets WITH (NOLOCK)
	WHERE provider_id = @pdts_provider_id;
	
	IF @min_year = @tax_year
		BEGIN
			SELECT @first_year = 1;
		END;
		
	SELECT 
		c.worksheet_id,
		ISNULL(p.last_name, '') AS last_name, 
		ISNULL(p.FIRST_NAME, '') AS first_name, 
		ISNULL(p.middle_name, '') AS middle_name, 
		f.name AS facility,
		CASE @first_year
			WHEN 1 THEN ISNULL(c.IG_BONUS, 0)
			ELSE 0
		END AS IG_BONUS,
		CASE @first_year
			WHEN 1 THEN ISNULL(c.INS_POLICY_PREMIUM_ALLOWANCE, 0) 
			ELSE 0
		END AS INS_POLICY_PREMIUM_ALLOWANCE,
		ISNULL((SELECT SUM(AMT_STUDENT_LOANS) FROM dbo.ig_Worksheet_CashRcpts WHERE WORKSHEET_ID = c.worksheet_id AND DATEPART(yyyy, check_date) = @tax_year), 0) AS student_loan_payments,
		ISNULL((SELECT SUM(AMT_EDUCATION_STIPEND) FROM dbo.ig_Worksheet_CashRcpts WHERE WORKSHEET_ID = c.worksheet_id AND DATEPART(yyyy, check_date) = @tax_year), 0) AS education_stipend_payments,
		ISNULL((SELECT SUM(AMT_SIGNON_BONUS) FROM dbo.ig_Worksheet_CashRcpts WHERE worksheet_id = c.worksheet_id AND DATEPART(yyyy, check_date) = @tax_year), 0) AS signon_bonus_payments,
		ISNULL((SELECT SUM(AMT_MARKETING_EXP) FROM dbo.ig_Worksheet_CashRcpts WHERE worksheet_id = c.worksheet_id AND DATEPART(yyyy, check_date) = @tax_year), 0) AS marketing_payments,
		ISNULL((SELECT SUM(AMT_RELOCATION_EXP) FROM dbo.ig_Worksheet_CashRcpts WHERE worksheet_id = c.worksheet_id AND DATEPART(yyyy, check_date) = @tax_year), 0) AS relocation_payments,
		ISNULL((SELECT SUM(ALLOWANCE_AMOUNT) FROM dbo.ig_Worksheet_Practice_Managment_Allowance WHERE worksheet_id = c.worksheet_id AND DATEPART(yyyy, allowance_date) = @tax_year), 0) AS practice_management_allowance,
		c.START_DATE,
		c.IMPUTED_INTEREST_RATE,
		c.FORGIVENESS_PERIOD,
		c.FORGIVENESS_INTEREST_RATE,
		c.MONTHS,
		CASE @first_year
			WHEN 1 THEN c.ADVPD_AMT_STUDENT_LOANS
			ELSE 0
		END AS advance_student_loans,
		CASE @first_year
			WHEN 1 THEN c.ADVPD_AMT_EDUCATION_STIPEND
			ELSE 0
		END as advance_education_stipend,
		CASE @first_year
			WHEN 1 THEN c.ADVPD_AMT_SIGNON_BONUS
			ELSE 0
		END AS advance_signon_bonus,
		CASE @first_year
			WHEN 1 THEN c.ADVPD_AMT_MARKETING_EXP 
			ELSE 0
		END AS advance_marketing_exp,
		CASE @first_year 
			WHEN 1 THEN c.ADVPD_AMT_RELOCATION_EXP
			ELSE 0
		END AS advance_relocation_exp
	FROM provider p WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON p.coid = f.COID
		
		JOIN dbo.ig_Worksheets c WITH (NOLOCK)
			ON p.PDTS_PROVIDER_ID = c.PROVIDER_ID
	WHERE p.PDTS_PROVIDER_ID = @pdts_provider_id
END

