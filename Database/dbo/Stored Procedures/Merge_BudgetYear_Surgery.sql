CREATE PROCEDURE [dbo].[Merge_BudgetYear_Surgery]
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
	SET b.inpatient = a.inpatient,
		b.outpatient = a.outpatient
	FROM BudgetYear_Surgery a
		JOIN BudgetYear_Surgery b
			ON a.year = b.YEAR
			AND a.monthno = b.MONTHNO
			AND a.SURGICAL_TYPE_ID = b.SURGICAL_TYPE_ID
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id
		AND b.pdts_provider_id = @target_pdts_provider_id
	
	INSERT INTO dbo.BudgetYear_Surgery
	        ( PDTS_PROVIDER_ID ,
	          SURGICAL_TYPE_ID ,
	          MONTHNO ,
	          YEAR ,
	          INPATIENT ,
	          OUTPATIENT ,
	          CREATE_DATE ,
	          CREATED_BY_USER_ID ,
	          UPDATE_DATE ,
	          UPDATED_BY_USER_ID
	        )
	SELECT @target_pdts_provider_id,
		a.SURGICAL_TYPE_ID,
		a.monthno,
		a.YEAR,
		a.INPATIENT,
		a.OUTPATIENT,
		a.create_date,
		a.created_by_user_id,
		a.update_date,
		a.updated_by_user_id
	FROM dbo.BudgetYear_Surgery a
	WHERE pdts_provider_id = @source_pdts_provider_id
		AND NOT EXISTS 
			(
				SELECT 1
				FROM dbo.BudgetYear_Surgery
				WHERE PDTS_PROVIDER_ID = @target_pdts_provider_id
					AND monthno = a.monthno
					AND year = a.year
					AND SURGICAL_TYPE_ID = a.SURGICAL_TYPE_ID
			);
	
	/*
	UPDATE dbo.BudgetYear_Surgery_Note_Xref
	SET PDTS_PROVIDER_ID = @target_pdts_provider_id
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;
	*/

	DECLARE @Budgetyear_Surgery_note_xref_id int
	DECLARE @source_Budgetyear_Surgery_id INT
	DECLARE @target_Budgetyear_Surgery_id int
	DECLARE @monthno INT
	DECLARE @year INT

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT b.Budgetyear_Surgery_note_xref_id, a.BudgetYEAR_Surgery_ID, a.monthno, a.YEAR
	FROM dbo.BudgetYear_Surgery a
		JOIN dbo.BudgetYear_Surgery_Note_Xref b
			ON a.BudgetYEAR_Surgery_ID = b.BudgetYEAR_Surgery_ID
	WHERE a.PDTS_PROVIDER_ID = @source_pdts_provider_id

	OPEN cur

	FETCH NEXT FROM cur
	INTO @Budgetyear_Surgery_note_xref_id, @source_Budgetyear_Surgery_id, @monthno, @year

	WHILE @@fetch_status = 0
		BEGIN
			SELECT @target_Budgetyear_Surgery_id = Budgetyear_Surgery_id
			FROM dbo.BudgetYear_Surgery
			WHERE pdts_provider_id = @target_pdts_provider_id
				AND MONTHNO = @monthno
				AND year = @year
			
			IF @target_Budgetyear_Surgery_id IS NOT NULL
				BEGIN
					IF NOT EXISTS
						(
							SELECT 1
							FROM BudgetYear_Surgery_Note_Xref
							WHERE BUDGETYEAR_SURGERY_ID = @target_Budgetyear_Surgery_id
						)
						begin
							UPDATE dbo.BudgetYear_Surgery_Note_Xref
							SET BudgetYEAR_Surgery_ID = @target_Budgetyear_Surgery_id
							WHERE BudgetYEAR_Surgery_NOTE_XREF_ID = @Budgetyear_Surgery_note_xref_id
						END
				END
				
			FETCH NEXT FROM cur
			INTO @Budgetyear_Surgery_note_xref_id, @source_Budgetyear_Surgery_id, @monthno, @year
		END
		
	CLOSE cur
	DEALLOCATE cur

	DELETE
	FROM dbo.BudgetYear_Surgery
	WHERE PDTS_PROVIDER_ID = @source_pdts_provider_id;
END

