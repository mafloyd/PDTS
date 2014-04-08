-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_ReturnSummedERDailyEntry]
(
	@coid VARCHAR(5),
	@er_stat_definition_id int,
	@month int,
	@year int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @retval int;

	SELECT @retval = day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + DAY_15 +
		day_16 + day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31
	FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
	WHERE coid = @coid
		AND ER_DAILY_STATS_DEFINITION_ID = @er_stat_definition_id
		AND month = @month
		AND year = @year;

	RETURN @retval;

END

