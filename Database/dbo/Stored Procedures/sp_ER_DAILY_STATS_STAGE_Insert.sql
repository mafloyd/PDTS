CREATE PROCEDURE [dbo].[sp_ER_DAILY_STATS_STAGE_Insert]
	(
		@coid VARCHAR(5),
		@er_daily_stats_definition_id INT,
		@year INT,
		@month INT,
		@day INT,
		@value INT,
		@provider_7a VARCHAR(100),
		@provider_11_11 VARCHAR(100),
		@provider_7p VARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO ER_DAILY_STATS_STAGE
		(
			coid,
			er_daily_stats_definition_id,
			YEAR,
			MONTH,
			DAY,
			VALUE,
			provider_7a,
			provider_11_11,
			provider_7p
		)
	VALUES
		(
			@coid,
			@er_daily_stats_definition_id,
			@year,
			@month,
			@day,
			@value,
			@Provider_7a,
			@provider_11_11,
			@provider_7p
		)  
END;

