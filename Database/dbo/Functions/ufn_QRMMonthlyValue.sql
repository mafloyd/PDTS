CREATE FUNCTION [dbo].[ufn_QRMMonthlyValue]
(
	@qrm_measure_type_id INT,
	@month INT,
	@year INT,
	@coid VARCHAR(5)
)
RETURNS INT
AS
BEGIN
	DECLARE @result int

	SELECT @result = ISNULL(VALUE, 0)
	FROM QRM_MEASURE
	WHERE QRM_MEASURE_TYPE_ID = @qrm_measure_type_id
		AND REPORTING_PERIOD_MONTH = @month
		AND REPORTING_PERIOD_YEAR = @year
		AND coid = @coid

	RETURN @result;

END

