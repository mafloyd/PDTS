CREATE PROCEDURE [dbo].[sp_report_ER_UpfrontCollections]
	(
		@division_id INT,
		@month INT,
		@year INT,
		@edm_managing_company_id INT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @results TABLE
		(
			coid varchar(5),
			facility varchar(50),
			division VARCHAR(50),
			MONTH INT,
			YEAR int,
			collection_percentage DECIMAL(5, 2),
			stat_definition VARCHAR(50),
			target_percentage DECIMAL(5, 2) DEFAULT 20,
			edm_managing_company_id INT,
			division_id int
		);

		INSERT INTO @results
			(
				coid,
				facility,
				division,
				month,
				year,
				collection_percentage,
				stat_definition,
				edm_managing_company_id,
				division_id
			)
		SELECT
			f.coid,
			f.name,
			d.name,
			@month,
			@year,
			percentage,
			'Upfront Collections',
			ISNULL(f.EDM_MANAGING_COMPANY_ID, 0),
			f.DIVISION_ID
		FROM division d WITH (NOLOCK)
			JOIN Facility f WITH (NOLOCK)
				ON d.division_id = f.DIVISION_ID

			LEFT JOIN dbo.ER_UPFRONT_COLLECTION c WITH (NOLOCK)
				ON f.COID = c.COID
				AND c.month = @month
				AND c.year = @year
		WHERE f.SHOW_IN_DETAIL_REPORTS = 1
		
	UPDATE @results
	SET collection_percentage = 0
	WHERE collection_percentage IS NULL;

	IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id;      
		END;
		      
	IF @edm_managing_company_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE ISNULL(edm_managing_company_id, 0) <> @edm_managing_company_id;
		END;
		      
	SELECT *
	FROM @results
	ORDER BY facility;    
END

