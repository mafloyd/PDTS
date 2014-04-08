
CREATE PROCEDURE [dbo].[sp_report_FacilityCombinedSurgeries]
	(
		@coids VARCHAR(100),
		@year INT,
		@month INT,
		@home_coid VARCHAR(5),
		@ytd BIT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @coid VARCHAR(5);
	DECLARE @surgical_type_id INT;
	DECLARE @first_name VARCHAR(50);
	DECLARE @last_name VARCHAR(50);
	DECLARE @provider_id INT;

	IF object_id('tempdb..#mercysurg') != NULL
		BEGIN
			DROP TABLE #mercysurg;
		END;

	CREATE TABLE #mercysurg
		(
			coid VARCHAR(5),
			pdts_provider_id INT,
			provider_id INT,
			first_name VARCHAR(50),
			last_name VARCHAR(50),
			specialty VARCHAR(50),
			surgical_type_id INT,
			surgical_type VARCHAR(50),
			cm_inpatient INT DEFAULT 0,
			cm_inpatient_budget INT DEFAULT 0,
			cm_inpatient_py INT DEFAULT 0,
			cm_outpatient INT DEFAULT 0,
			cm_outpatient_budget INT DEFAULT 0,
			cm_outpatient_py INT DEFAULT 0
		);

	CREATE NONCLUSTERED INDEX #mercysurg_idx1 ON #mercysurg (coid);

	DECLARE @data TABLE
		(
			coid VARCHAR(5),
			pdts_provider_id INT,
			provider_id INT,
			first_name VARCHAR(50),
			last_name VARCHAR(50),
			specialty VARCHAR(50),
			surgical_type_id INT,
			surgical_type VARCHAR(50),
			cm_inpatient INT DEFAULT 0,
			cm_inpatient_budget INT DEFAULT 0,
			cm_inpatient_py INT DEFAULT 0,
			cm_outpatient INT DEFAULT 0,
			cm_outpatient_budget INT DEFAULT 0,
			cm_outpatient_py INT DEFAULT 0
		);  

	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT items FROM dbo.Split(@coids, ',')  

	OPEN cur

	FETCH NEXT FROM cur
	INTO @coid;

	WHILE @@fetch_status = 0
		BEGIN      
			SELECT @surgical_type_id = 1;

			WHILE @surgical_type_id <= 5
				begin
					--INSERT INTO @data (coid, pdts_provider_id, provider_id, first_name, last_name, specialty, surgical_type_id, surgical_type)
					--SELECT @coid, p.pdts_provider_id, p.provider_id, p.first_name, p.last_name, s.LONG_NAME, @surgical_type_id, (SELECT LONG_NAME FROM dbo.Surgical_Type WITH (NOLOCK) WHERE surgical_type_id = @surgical_type_id)
					--FROM Provider p WITH (NOLOCK)
					--	LEFT JOIN dbo.Specialty s WITH (NOLOCK)
					--		ON p.SPECIALTY_ID = s.SPECIALTY_ID
					--WHERE coid = @coid;

					INSERT INTO #mercysurg (coid, pdts_provider_id, provider_id, first_name, last_name, specialty, surgical_type_id, surgical_type)
					SELECT @coid, p.pdts_provider_id, p.provider_id, p.first_name, p.last_name, s.LONG_NAME, @surgical_type_id, (SELECT LONG_NAME FROM dbo.Surgical_Type WITH (NOLOCK) WHERE surgical_type_id = @surgical_type_id)
					FROM Provider p WITH (NOLOCK)
						LEFT JOIN dbo.Specialty s WITH (NOLOCK)
							ON p.SPECIALTY_ID = s.SPECIALTY_ID
					WHERE coid = @coid;

					IF @ytd = 0
						begin
							UPDATE a
							SET a.cm_inpatient = ISNULL(
								(
									SELECT inpatient
									FROM CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = @year
										AND cys.MONTHNO = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE 
						BEGIN
							UPDATE a
							SET a.cm_inpatient = ISNULL(
								(
									SELECT SUM(inpatient)
									FROM CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = @year
										AND cys.MONTHNO <= @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;                      
						END;                      

					IF @ytd = 0
						begin
							UPDATE a
							SET a.cm_inpatient_budget = ISNULL(
								(
									SELECT inpatient
									FROM dbo.BudgetYear_Surgery bys WITH (NOLOCK)
									WHERE bys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND bys.SURGICAL_TYPE_ID = @surgical_type_id
										AND bys.year = @year
										AND bys.MONTHNO = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE
						BEGIN
							UPDATE a
							SET a.cm_inpatient_budget = ISNULL(
								(
									SELECT SUM(inpatient)
									FROM dbo.BudgetYear_Surgery bys WITH (NOLOCK)
									WHERE bys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND bys.SURGICAL_TYPE_ID = @surgical_type_id
										AND bys.year = @year
										AND bys.MONTHNO <= @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;                      
						END;                  

					IF @ytd = 0
						BEGIN
							UPDATE a
							SET a.cm_inpatient_py = ISNULL(
								(
									SELECT inpatient
									FROM dbo.CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = (@year - 1)
										AND cys.monthno = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE
						BEGIN
							UPDATE a
							SET a.cm_inpatient_py = ISNULL(
								(
									SELECT SUM(inpatient)
									FROM dbo.CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = (@year - 1)
										AND cys.monthno <= @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;                      
						END;                  

					IF @ytd = 0
						begin
							UPDATE a
							SET a.cm_outpatient = ISNULL(
								(
									SELECT outpatient
									FROM CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = @year
										AND cys.MONTHNO = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE
						BEGIN
							UPDATE a
							SET a.cm_outpatient = ISNULL(
								(
									SELECT SUM(outpatient)
									FROM CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = @year
										AND cys.MONTHNO <= @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;                      
						END;                  

					IF @ytd = 0
						begin
							UPDATE a
							SET a.cm_outpatient_budget = ISNULL(
								(
									SELECT outpatient
									FROM dbo.BudgetYear_Surgery bys WITH (NOLOCK)
									WHERE bys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND bys.SURGICAL_TYPE_ID = @surgical_type_id
										AND bys.year = @year
										AND bys.MONTHNO = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE
						BEGIN
							UPDATE a
							SET a.cm_outpatient_budget = ISNULL(
								(
									SELECT SUM(outpatient)
									FROM dbo.BudgetYear_Surgery bys WITH (NOLOCK)
									WHERE bys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND bys.SURGICAL_TYPE_ID = @surgical_type_id
										AND bys.year = @year
										AND bys.MONTHNO <= @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;                      
						END;                  

					IF @ytd = 0
						begin
							UPDATE a
							SET a.cm_outpatient_py = ISNULL(
								(
									SELECT outpatient
									FROM dbo.CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = (@year - 1)
										AND cys.monthno = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;
					ELSE
						BEGIN
							UPDATE a
							SET a.cm_outpatient_py = ISNULL(
								(
									SELECT SUM(outpatient)
									FROM dbo.CurrentYear_Surgery cys WITH (NOLOCK)
									WHERE cys.PDTS_PROVIDER_ID = a.pdts_provider_id
										AND cys.SURGICAL_TYPE_ID = @surgical_type_id
										AND cys.year = (@year - 1)
										AND cys.monthno = @month
								), 0)
							FROM #mercysurg a
							WHERE a.surgical_type_id = @surgical_type_id;
						END;                  

					SELECT @surgical_type_id = @surgical_type_id + 1;
				END;

			FETCH NEXT FROM cur
			INTO @coid;      
		END;
		
	CLOSE cur;
	DEALLOCATE cur;      

	-- process to attempt to get to one id
	IF @home_coid <> ''
		begin
		DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT first_name, last_name
		FROM #mercysurg
		WHERE (cm_inpatient <> 0 OR cm_inpatient_budget <> 0 OR cm_inpatient_py <> 0 OR cm_outpatient <> 0 OR cm_outpatient_budget <> 0 OR cm_outpatient_py <> 0)
		GROUP BY first_name, last_name
		HAVING COUNT(last_name) > 1
	
		OPEN cur
	
		FETCH NEXT FROM cur
		INTO @first_name, @last_name
	
		WHILE @@fetch_status = 0
			BEGIN
				SELECT @provider_id = provider_id
				FROM #mercysurg
				WHERE coid = @home_coid
					and first_name = @first_name
					AND last_name = @last_name

				IF @provider_id IS NOT NULL
					BEGIN
						UPDATE #mercysurg
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
	  
	--SELECT first_name, last_name, specialty, surgical_type, SUM(cm_inpatient) AS cm_inpatient
	SELECT 
		provider_id,
		first_name,
		last_name,
		specialty,
		surgical_type_id,
		surgical_type,
		SUM(cm_inpatient) AS cm_inpatient,
		SUM(cm_inpatient_budget) AS cm_inpatient_budget,
		SUM(cm_inpatient_py) AS cm_inpatient_py,
		SUM(cm_outpatient) AS cm_outpatient,
		SUM(cm_outpatient_budget) AS cm_outpatient_budget,
		SUM(cm_outpatient_py) AS cm_outpatient_py
	FROM #mercysurg
	WHERE (cm_inpatient <> 0 OR cm_inpatient_budget <> 0 OR cm_inpatient_py <> 0 OR cm_outpatient <> 0 OR cm_outpatient_budget <> 0 OR cm_outpatient_py <> 0)
	GROUP BY provider_id, first_name, last_name, specialty, surgical_type_id, surgical_type
	ORDER BY specialty, last_name, first_name
END;


