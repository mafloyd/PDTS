CREATE PROCEDURE [dbo].[sp_ER_MONTHLY_DATA_STAGE_Cleanup]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- delete any patient who has only 1 record of charge_rev_code = 762
    DELETE
	FROM ER_MONTHLY_DATA_STAGE
	WHERE ER_DATA_STAGE_ID IN 
		(
			SELECT a.ER_DATA_STAGE_ID
			FROM ER_MONTHLY_DATA_STAGE a
			WHERE a.CHARGE_REV_CODE = 762
				AND NOT EXISTS
					(
						SELECT 1
						FROM dbo.ER_MONTHLY_DATA_STAGE
						WHERE coid = a.coid
							AND PAT_NUM = a.PAT_NUM
							AND charge_rev_code <> 762
					)
		)
	
	DECLARE @t TABLE
		(
			coid VARCHAR(5),
			pat_num VARCHAR(50)
		);
		
	INSERT INTO @t
		(
			coid,
			pat_num
		)
	SELECT coid, pat_num
	FROM dbo.ER_MONTHLY_DATA_STAGE
	GROUP BY COID, PAT_NUM
	HAVING COUNT(pat_num) = 2;
	
	DECLARE @coid VARCHAR(5)
	DECLARE @pat_num VARCHAR(50)
	DECLARE @er_data_stage_id int
	
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT coid, pat_num
	FROM @t
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @coid, @pat_num
	
	WHILE @@fetch_status = 0
		BEGIN
			IF EXISTS
				(
					SELECT 1
					FROM ER_MONTHLY_DATA_STAGE WITH (NOLOCK)
					WHERE coid = @coid
						AND pat_num = @pat_num
						AND charge_rev_code = 450
				)
				BEGIN
					IF EXISTS 
						(
							SELECT 1
							FROM ER_MONTHLY_DATA_STAGE WITH (NOLOCK)
							WHERE coid = @coid
								AND pat_num = @pat_num
								AND charge_rev_code <> 450
						)
						BEGIN
							DELETE
							FROM dbo.ER_MONTHLY_DATA_STAGE
							WHERE coid = @coid
								AND pat_num = @pat_num
								AND charge_rev_code <> 450;
								
							UPDATE dbo.ER_MONTHLY_DATA_STAGE
							SET OBSERVATION = 1
							WHERE coid = @coid
								AND pat_num = @pat_num
								AND charge_rev_code = 450;
						END;
				END;
				
			FETCH NEXT FROM cur
			INTO @coid, @pat_num                
		END
		
	CLOSE cur;
	DEALLOCATE cur;
	
	declare @t1 TABLE
		(
			coid varchar(5),
			pat_num varchar(50)
		)
		
	INSERT INTO @t1
		(
			coid,
			pat_num
		)
	SELECT coid, pat_num
	FROM dbo.ER_MONTHLY_DATA_STAGE
	GROUP BY COID, PAT_NUM
	HAVING COUNT(pat_num) > 1;
	
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT coid, pat_num
	FROM @t1
	
	OPEN cur
	
	FETCH NEXT FROM cur
	INTO @coid, @pat_num
	
	WHILE @@fetch_status = 0
		BEGIN
			IF EXISTS
				(
					SELECT 1
					FROM ER_MONTHLY_DATA_STAGE WITH (NOLOCK)
					WHERE coid = @coid
						AND pat_num = @pat_num
						AND charge_rev_code <> 450
				)
				BEGIN
					UPDATE dbo.ER_MONTHLY_DATA_STAGE
					SET OBSERVATION = 1
					WHERE coid = @coid
						AND pat_num = @pat_num;
				END;
			
			/*	
			SELECT TOP 1 @er_data_stage_id = a.er_data_stage_id
			FROM er_data_stage a 
				JOIN dbo.MASTER_ER_LEVEL b
					ON a.charge_cpt_code = b.CPT_CODE
			WHERE a.coid = @coid
				AND a.pat_num = @pat_num
			ORDER BY b.CPT_CODE DESC;
			
			IF @er_data_stage_id IS NOT NULL
				BEGIN
					DELETE
					FROM dbo.ER_DATA_STAGE
					WHERE coid = @coid
						AND pat_num = @pat_num
						AND er_data_stage_id <> @er_data_stage_id;
				END;
			*/
			FETCH NEXT FROM cur
			INTO @coid, @pat_num                
		END
		
	CLOSE cur
	DEALLOCATE cur
END

