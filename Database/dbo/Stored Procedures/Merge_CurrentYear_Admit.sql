CREATE PROCEDURE [dbo].[Merge_CurrentYear_Admit]
	(
		@source_pdts_provider_id INT,
		@target_pdts_provider_id int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE b
	SET b.admits = a.admits
	FROM CurrentYear_Admit a
		JOIN CurrentYear_Admit b
			ON a.year = b.YEAR
			AND a.monthno = b.MONTHNO
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id
		AND b.pdts_provider_id = @target_pdts_provider_id
	
	INSERT INTO dbo.CurrentYear_Admit
			( PDTS_PROVIDER_ID ,
			  MONTHNO ,
			  YEAR ,
			  ADMITS ,
			  CREATE_DATE ,
			  CREATED_BY_USER_ID ,
			  UPDATE_DATE ,
			  UPDATED_BY_USER_ID
			)
	SELECT @target_pdts_provider_id,
		a.monthno,
		a.YEAR,
		a.admits,
		a.create_date,
		a.created_by_user_id,
		a.update_date,
		a.updated_by_user_id
	FROM dbo.CurrentYear_Admit a
	WHERE pdts_provider_id = @source_pdts_provider_id
		AND NOT EXISTS 
			(
				SELECT 1
				FROM dbo.CurrentYear_Admit
				WHERE PDTS_PROVIDER_ID = @target_pdts_provider_id
					AND monthno = a.monthno
					AND year = a.year
			);
		
	UPDATE dbo.CurrentYear_Admit_Note_Xref
	SET PDTS_PROVIDER_ID = @target_pdts_provider_id
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;

	DECLARE @currentyear_admit_note_xref_id int
	DECLARE @source_currentyear_admit_id INT
	DECLARE @target_currentyear_admit_id int
	DECLARE @monthno INT
	DECLARE @year INT

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT b.currentyear_admit_note_xref_id, a.CURRENTYEAR_ADMIT_ID, a.monthno, a.YEAR
	FROM dbo.CurrentYear_Admit a
		JOIN dbo.CurrentYear_Admit_Note_Xref b
			ON a.CURRENTYEAR_ADMIT_ID = b.CURRENTYEAR_ADMIT_ID
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id

	OPEN cur

	FETCH NEXT FROM cur
	INTO @currentyear_admit_note_xref_id, @source_currentyear_admit_id, @monthno, @year

	WHILE @@fetch_status = 0
		BEGIN
			SELECT @target_currentyear_admit_id = currentyear_admit_id
			FROM dbo.CurrentYear_Admit
			WHERE pdts_provider_id = @target_pdts_provider_id
				AND MONTHNO = @monthno
				AND year = @year
			
			IF @target_currentyear_admit_id IS NOT NULL
				BEGIN
					UPDATE dbo.CurrentYear_Admit_Note_Xref
					SET CURRENTYEAR_ADMIT_ID = @target_currentyear_admit_id
					WHERE CURRENTYEAR_ADMIT_NOTE_XREF_ID = @currentyear_admit_note_xref_id
				END
				
			FETCH NEXT FROM cur
			INTO @currentyear_admit_note_xref_id, @source_currentyear_admit_id, @monthno, @year
		END
		
	CLOSE cur
	DEALLOCATE cur

	DELETE
	FROM dbo.CurrentYear_Admit
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;
END

