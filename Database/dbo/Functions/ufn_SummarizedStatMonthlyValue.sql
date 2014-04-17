CREATE FUNCTION [dbo].[ufn_SummarizedStatMonthlyValue]
(
	@coid VARCHAR(5),
	@year INT,
	@month INT,
	@summarized_stat_definition_id INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
	DECLARE @result decimal(18, 2)
	
	IF @month = 1
		BEGIN
			SELECT @result = JAN
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END;
	ELSE IF @month = 2
		BEGIN
			SELECT @result = FEB
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 3
		BEGIN
			SELECT @result = MAR
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 4
		BEGIN
			SELECT @result = APR
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 5
		BEGIN
			SELECT @result = MAY
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 6
		BEGIN
			SELECT @result = JUN
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 7
		BEGIN
			SELECT @result = JUL
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 8
		BEGIN
			SELECT @result = AUG
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 9
		BEGIN
			SELECT @result = SEP
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 10
		BEGIN
			SELECT @result = OCT
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 11
		BEGIN
			SELECT @result = NOV
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 
	ELSE IF @month = 12
		BEGIN
			SELECT @result = DEC
			FROM dbo.SUMMARIZED_STATS WITH (NOLOCK)
			WHERE coid = @coid
				AND year = @year
				AND SUMMARIZED_STAT_DEFINITION_ID = @summarized_stat_definition_id;
		END; 

	RETURN @result

END

