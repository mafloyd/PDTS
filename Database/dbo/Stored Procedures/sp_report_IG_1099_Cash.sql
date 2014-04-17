CREATE PROCEDURE [dbo].[sp_report_IG_1099_Cash]
(
	@worksheet_id int
)
AS
BEGIN
	SELECT 
		DATE_SUBMITTED_PHYS,
		ISNULL(AMT_STUDENT_LOANS, 0) AS amt_student_loans,
		ISNULL(AMT_EDUCATION_STIPEND, 0) AS amt_education_stipend,
		ISNULL(AMT_SIGNON_BONUS, 0) AS amt_signon_bonus,
		ISNULL(AMT_MARKETING_EXP, 0) AS amt_marketing_exp,
		ISNULL(AMT_RELOCATION_EXP, 0) AS amt_relocation_exp,
		ISNULL(CASH_RECEIPTS, 0) AS cash_receipts,
		ISNULL(NET_CHK_AMT_DUE_TO_PHYS, 0) AS net_check_amount_due_physician,
		month
	FROM dbo.ig_Worksheet_CashRcpts
	WHERE WORKSHEET_ID = @worksheet_id
	ORDER BY month;
END

