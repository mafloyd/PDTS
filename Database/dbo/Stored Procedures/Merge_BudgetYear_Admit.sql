CREATE PROCEDURE [dbo].[Merge_BudgetYear_Admit]
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
	FROM BudgetYear_Admit a
		JOIN BudgetYear_Admit b
			ON a.year = b.YEAR
			AND a.monthno = b.MONTHNO
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id
		AND b.pdts_provider_id = @target_pdts_provider_id
	
	INSERT INTO dbo.BudgetYear_Admit
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
	FROM dbo.BudgetYear_Admit a
	WHERE pdts_provider_id = @source_pdts_provider_id
		AND NOT EXISTS 
			(
				SELECT 1
				FROM dbo.BudgetYear_Admit
				WHERE PDTS_PROVIDER_ID = @target_pdts_provider_id
					AND monthno = a.monthno
					AND year = a.year
			);
		
	UPDATE dbo.BudgetYear_Admit_Note_Xref
	SET PDTS_PROVIDER_ID = @target_pdts_provider_id
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;

	DECLARE @Budgetyear_admit_note_xref_id int
	DECLARE @source_Budgetyear_admit_id INT
	DECLARE @target_Budgetyear_admit_id int
	DECLARE @monthno INT
	DECLARE @year INT

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT b.Budgetyear_admit_note_xref_id, a.BudgetYEAR_ADMIT_ID, a.monthno, a.YEAR
	FROM dbo.BudgetYear_Admit a
		JOIN dbo.BudgetYear_Admit_Note_Xref b
			ON a.BudgetYEAR_ADMIT_ID = b.BudgetYEAR_ADMIT_ID
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id

	OPEN cur

	FETCH NEXT FROM cur
	INTO @Budgetyear_admit_note_xref_id, @source_Budgetyear_admit_id, @monthno, @year

	WHILE @@fetch_status = 0
		BEGIN
			SELECT @target_Budgetyear_admit_id = Budgetyear_admit_id
			FROM dbo.BudgetYear_Admit
			WHERE pdts_provider_id = @target_pdts_provider_id
				AND MONTHNO = @monthno
				AND year = @year
			
			IF @target_Budgetyear_admit_id IS NOT NULL
				BEGIN
					UPDATE dbo.BudgetYear_Admit_Note_Xref
					SET BudgetYEAR_ADMIT_ID = @target_Budgetyear_admit_id
					WHERE BudgetYEAR_ADMIT_NOTE_XREF_ID = @Budgetyear_admit_note_xref_id
				END
				
			FETCH NEXT FROM cur
			INTO @Budgetyear_admit_note_xref_id, @source_Budgetyear_admit_id, @monthno, @year
		END
		
	CLOSE cur
	DEALLOCATE cur

	DELETE
	FROM dbo.BudgetYear_Admit
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;
END

