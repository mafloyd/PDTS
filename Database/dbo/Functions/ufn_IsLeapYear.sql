CREATE FUNCTION [dbo].[ufn_IsLeapYear] ( @pYear int )
RETURNS BIT
AS
BEGIN

    IF ((@pYear % 4) = 0 AND (@pYear % 100 != 0) OR
        @pYear % 400 = 0)
        RETURN 1

    RETURN 0

END

