CREATE PROCEDURE [dbo].[sp_ER_DAILY_STATS_Insert_From_ER_DAILY_STATS_STAGE]
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @coid VARCHAR(5)
	DECLARE @year INT
	
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT DISTINCT coid, YEAR
	FROM dbo.ER_DAILY_STATS_STAGE
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @coid, @year
	
	WHILE @@fetch_status = 0
		BEGIN
			DELETE
			FROM dbo.ER_DAILY_STATS
			WHERE coid = @coid
				AND year = @year;
				
			FETCH NEXT FROM cur
			INTO @coid, @year
		END
	
	CLOSE cur
	DEALLOCATE cur
	
	INSERT INTO dbo.ER_DAILY_STATS
	        ( COID ,
	          ER_DAILY_STATS_DEFINITION_ID ,
	          YEAR ,
	          MONTH ,
	          DAY ,
	          VALUE ,
	          PROVIDER_7A ,
	          PROVIDER_11_11 ,
	          PROVIDER_7P ,
	          CREATE_DATE
	        )
	SELECT
		coid,
		ER_DAILY_STATS_DEFINITION_ID,
		year,
		month,
		day,
		value,
		provider_7a,
		provider_11_11,
		PROVIDER_7P,
		CREATE_DATE
	FROM dbo.ER_DAILY_STATS_STAGE;
	
	TRUNCATE TABLE dbo.ER_DAILY_STATS_STAGE;
END

