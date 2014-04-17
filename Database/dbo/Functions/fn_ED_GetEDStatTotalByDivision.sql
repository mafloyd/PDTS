CREATE FUNCTION [dbo].[fn_ED_GetEDStatTotalByDivision]
(
	@er_stat_definition_id INT,
	@division_id INT,
	@report_date datetime
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
	DECLARE @month INT;
	DECLARE @day INT;
	DECLARE @year INT;
	DECLARE @value DECIMAL(18, 2);

	SELECT @month = DATEPART(mm, @report_date);
	SELECT @day = DATEPART(dd, @report_date);
	SELECT @year = DATEPART(yyyy, @report_date);

	RETURN @value;
END

