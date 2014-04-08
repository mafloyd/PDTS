CREATE PROCEDURE [dbo].[sp_report_IG_MostRecentCheck] 
	(
		@receipt_id int
	)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 check_date, check_number, CEO_CFO_INITIALS
	FROM dbo.ig_Worksheet_CashRcpt_Check
	WHERE RECEIPT_ID = @receipt_id
	ORDER BY check_date DESC;
END

