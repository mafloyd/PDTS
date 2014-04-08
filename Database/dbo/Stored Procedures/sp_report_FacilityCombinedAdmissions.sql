CREATE PROCEDURE [dbo].[sp_report_FacilityCombinedAdmissions]
	(
		@coids VARCHAR(100),
		@year INT,
		@month INT,
		@home_coid VARCHAR(5)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @coid VARCHAR(5);
	DECLARE @provider_id INT;
	DECLARE @first_name VARCHAR(50);
	DECLARE @last_name VARCHAR(50);
	DECLARE @comments VARCHAR(1000);

	DECLARE @data TABLE
		(
			coid VARCHAR(5),
			pdts_provider_id INT,
			provider_id INT,
			first_name VARCHAR(50),
			last_name VARCHAR(50),
			specialty VARCHAR(50),
			cm_admits INT DEFAULT 0,
			cm_budget_admits INT DEFAULT 0,
			cm_py_admits INT DEFAULT 0,
			cm_ytd_admits INT DEFAULT 0,
			cm_ytd_budget_admits INT DEFAULT 0,
			cm_pytd_admits INT DEFAULT 0,
			comments VARCHAR(1000)
		);  

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT items FROM dbo.Split(@coids, ',')  

	OPEN cur

	FETCH NEXT FROM cur
	INTO @coid;

	WHILE @@fetch_status = 0
		BEGIN      
			INSERT INTO @data (coid, pdts_provider_id, provider_id, first_name, last_name, specialty)
			SELECT @coid, p.pdts_provider_id, p.provider_id, p.first_name, p.last_name, s.LONG_NAME
			FROM Provider p WITH (NOLOCK)
				LEFT JOIN dbo.Specialty s WITH (NOLOCK)
					ON p.SPECIALTY_ID = s.SPECIALTY_ID
			WHERE coid = @coid;

			UPDATE a
			SET a.cm_admits = ISNULL(
				(
					SELECT admits
					FROM dbo.CurrentYear_Admit cya WITH (NOLOCK)
					WHERE cya.pdts_provider_id = a.pdts_provider_id
						AND cya.year = @year
						AND cya.monthno = @month
				), 0)
			FROM @data a

			UPDATE a
			SET a.cm_budget_admits = ISNULL(
				(
					SELECT admits
					FROM BudgetYear_Admit bya WITH (NOLOCK)
					WHERE bya.pdts_provider_id = a.pdts_provider_id
						AND bya.year = @year
						AND bya.monthno = @month
				), 0)
			FROM @data a

			UPDATE a
			SET a.cm_py_admits = ISNULL(
				(
					SELECT admits
					FROM CurrentYear_Admit cya WITH (NOLOCK)
					WHERE cya.pdts_provider_id = a.pdts_provider_id
						AND cya.year = (@year - 1)
						AND cya.monthno = @month
				), 0)
			FROM @data a

			UPDATE a
			SET a.cm_ytd_admits = ISNULL(
				(
					SELECT SUM(admits)
					FROM CurrentYear_Admit cya WITH (NOLOCK)
					WHERE cya.pdts_provider_id = a.pdts_provider_id
						AND cya.year = @year
						AND cya.monthno <= @month
				), 0)
			FROM @data a;

			UPDATE a
			SET a.cm_ytd_budget_admits = ISNULL(
				(
					SELECT SUM(admits)
					FROM BudgetYear_Admit bya WITH (NOLOCK)
					WHERE bya.pdts_provider_id = a.pdts_provider_id
						AND bya.YEAR = @year
						AND bya.monthno <= @month
				), 0)
			FROM @data a;

			UPDATE a
			SET a.cm_pytd_admits = ISNULL(
				(
					SELECT SUM(admits)
					FROM dbo.CurrentYear_Admit cya WITH (NOLOCK)
					WHERE cya.PDTS_PROVIDER_ID = a.pdts_provider_id
						AND cya.year = (@year - 1)
						AND cya.MONTHNO <= @month
				), 0)
			FROM @data a;

			UPDATE a
			SET a.comments = 
				(
					SELECT c.note
					FROM CurrentYear_Admit cya WITH (NOLOCK)
						JOIN dbo.CurrentYear_Admit_Note_Xref xref WITH (NOLOCK)
							ON cya.CURRENTYEAR_ADMIT_ID = xref.CURRENTYEAR_ADMIT_ID
							
						JOIN Note c WITH (NOLOCK)
							ON xref.NOTE_ID = c.NOTE_ID
					WHERE cya.PDTS_PROVIDER_ID = a.pdts_provider_id
						AND cya.year = @year
						AND cya.MONTHNO = @month 
				)
			FROM @data a;

			FETCH NEXT FROM cur
			INTO @coid;      
		END;
		
	CLOSE cur;
	DEALLOCATE cur;      

	IF @home_coid <> ''
		begin
			DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT first_name, last_name
			FROM @data
			WHERE (cm_admits <> 0 OR cm_budget_admits <> 0 OR cm_py_admits <> 0 OR cm_ytd_admits <> 0 OR cm_ytd_budget_admits <> 0 OR cm_pytd_admits <> 0)
			GROUP BY first_name, last_name
			HAVING COUNT(last_name) > 1
	
			OPEN cur
	
			FETCH NEXT FROM cur
			INTO @first_name, @last_name
	
			WHILE @@fetch_status = 0
				BEGIN
					SELECT @provider_id = provider_id
					FROM @data
					WHERE coid = @home_coid
						and first_name = @first_name
						AND last_name = @last_name

					IF @provider_id IS NOT NULL
						BEGIN
							UPDATE @data
							SET provider_id = @provider_id
							WHERE coid <> @home_coid
								AND first_name = @first_name
								AND last_name = @last_name              
						END;
				          
					FETCH NEXT FROM cur
					INTO @first_name, @last_name      
				END;
		
			CLOSE cur;
			DEALLOCATE cur;
		END;

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT provider_id, first_name, last_name
	FROM @data
	GROUP BY provider_id, first_name, last_name
	HAVING COUNT(last_name) > 1

	OPEN cur

	FETCH NEXT FROM cur
	INTO @provider_id, @first_name, @last_name

	WHILE @@fetch_status = 0
		BEGIN
			SELECT @comments = (SELECT top 1 comments FROM @data WHERE provider_id = @provider_id AND first_name = @first_name AND last_name = @last_name AND comments IS NOT null);
				
			IF @comments IS NOT NULL
				BEGIN
					UPDATE @data
					SET comments = @comments
					WHERE provider_id = @provider_id
						AND first_name = @first_name
						AND last_name = @last_name;              
				END;	      
			FETCH NEXT FROM cur
			INTO @provider_id, @first_name, @last_name      
		END;
		
	CLOSE cur;
	DEALLOCATE cur;      
	SELECT provider_id,
		first_name,
		last_name,
		specialty,
		comments,
		SUM(cm_admits) AS cm_admits,
		SUM(cm_budget_admits) AS cm_budget_admits,
		SUM(cm_py_admits) AS cm_py_admits,
		SUM(cm_ytd_admits) AS cm_ytd_admits,
		SUM(cm_ytd_budget_admits) AS cm_ytd_budget_admits,
		SUM(cm_pytd_admits) AS cm_pytd_admits
	FROM @data
	WHERE (cm_admits <> 0 OR cm_budget_admits <> 0 OR cm_py_admits <> 0 OR cm_ytd_admits <> 0 OR cm_ytd_budget_admits <> 0 OR cm_pytd_admits <> 0)
	GROUP BY provider_id, first_name, last_name, specialty, comments
	ORDER BY specialty, last_name, first_name
END;

