CREATE PROCEDURE [dbo].[sp_report_IG_DataDump]
AS
BEGIN
	SET NOCOUNT ON;

	IF object_id('tempdb..#ig') IS NOT NULL	
		BEGIN
			DROP TABLE #ig;      
		END;      

	CREATE TABLE #ig
	(
		worksheet_id INT,
		facility VARCHAR(50),
		last_name VARCHAR(50),
		first_name VARCHAR(50),
		specialty VARCHAR(50),
		pdts_provider_id INT,
		ig_status VARCHAR(50),
		ig_type VARCHAR(50),
		START_DATE DATETIME,
		physician_salary MONEY,
		months INT,
		total_cash_receipts MONEY,
		total_gross_charges MONEY,
		total_visits INT,
		total_expenses MONEY
	);  

	INSERT INTO #ig (worksheet_id, facility, last_name, first_name, specialty, pdts_provider_id, ig_status, ig_type, start_date, physician_salary, months)
	SELECT ig.WORKSHEET_ID, f.NAME, p.last_name, p.first_name, s.long_name, p.pdts_provider_id, igs.IGSTATUS_DESC, igt.IGTYPE_DESC, ig.START_DATE, ig.PHYSICIAN_SALARY, ig.months
	FROM Facility f WITH (NOLOCK)
		JOIN Provider p WITH (NOLOCK)
			ON f.coid = p.COID
		
		JOIN dbo.ig_Worksheets ig WITH (NOLOCK)
			ON p.PDTS_PROVIDER_ID = ig.PROVIDER_ID

		JOIN Specialty s WITH (NOLOCK)
			ON p.specialty_id = s.specialty_id

		LEFT JOIN dbo.ig_Status igs WITH (NOLOCK)
			ON ig.IGSTATUS_ID = igs.IGSTATUS_ID

		LEFT JOIN dbo.ig_Type igt WITH (NOLOCK)
			ON ig.IGTYPE_ID = igt.IGTYPE_ID

	UPDATE a
	SET a.total_cash_receipts =
		(
			SELECT SUM(CASH_RECEIPTS)
			FROM dbo.ig_Worksheet_CashRcpts WITH (NOLOCK)
			WHERE WORKSHEET_ID = a.worksheet_id
		)
	FROM #ig a;

	UPDATE a
	SET a.total_gross_charges = 
		(
			SELECT SUM(GROSS_CHARGES)
			FROM dbo.ig_Worksheet_CashRcpts WITH (NOLOCK)
			WHERE WORKSHEET_ID = a.worksheet_id
		)
	FROM #ig a;

	UPDATE a
	SET a.total_visits = 
		(
			SELECT SUM(TOTAL_VISITS)
			FROM dbo.ig_Worksheet_CashRcpts WITH (NOLOCK)
			WHERE WORKSHEET_ID = a.worksheet_id
		)
	FROM #ig a;

	UPDATE a
	SET a.total_expenses = 
		(
			SELECT SUM(EXPENSE_TOTAL)
			FROM dbo.ig_Worksheet_CashRcpts WITH (NOLOCK)
			WHERE WORKSHEET_ID = a.worksheet_id
		)
	FROM #ig a;

	DECLARE @worksheet_total int;
	DECLARE @worksheet_counter INT;
	DECLARE @column sysname;
	DECLARE @sql VARCHAR(4000);

	SELECT @worksheet_total = 
		(
			SELECT TOP 1 COUNT(b.RECEIPT_ID)
			FROM dbo.ig_Worksheets a WITH (NOLOCK)
				JOIN dbo.ig_Worksheet_CashRcpts b WITH (NOLOCK)
					ON a.WORKSHEET_ID = b.WORKSHEET_ID
			GROUP BY a.WORKSHEET_ID
			ORDER BY COUNT(b.receipt_id) DESC
		);          

	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'cr' + CAST(@worksheet_counter AS VARCHAR(2))
			SELECT @worksheet_counter = @worksheet_counter + 1;   
			
			SELECT @sql = 'alter table #ig add ' + @column + ' money null default 0';
			--PRINT @sql
			EXEC (@sql);
		END;
		      
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'cr' + CAST(@worksheet_counter AS VARCHAR(2));      
			
			SELECT @sql = 'update a set ' + @column + ' = (select isnull(cash_receipts, 0) from ig_Worksheet_CashRcpts where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS VARCHAR(2)) + ') from #ig a'
			--PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;      
		END;

	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'gc' + CAST(@worksheet_counter AS VARCHAR(2))
			SELECT @worksheet_counter = @worksheet_counter + 1;   
			
			SELECT @sql = 'alter table #ig add ' + @column + ' money null default 0';
			--PRINT @sql
			EXEC (@sql);
		END;
		      
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'gc' + CAST(@worksheet_counter AS VARCHAR(2));      
			
			SELECT @sql = 'update a set ' + @column + ' = (select gross_charges from ig_Worksheet_CashRcpts where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS VARCHAR(2)) + ') from #ig a'
			--PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;      
		END;
		    
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'tv' + CAST(@worksheet_counter AS VARCHAR(2))
			SELECT @worksheet_counter = @worksheet_counter + 1;   
			
			SELECT @sql = 'alter table #ig add ' + @column + ' int null default 0';
			--PRINT @sql
			EXEC (@sql);
		END;
		      
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'tv' + CAST(@worksheet_counter AS VARCHAR(2));      
			
			SELECT @sql = 'update a set ' + @column + ' = (select total_visits from ig_Worksheet_CashRcpts where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS VARCHAR(2)) + ') from #ig a'
			--PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;      
		END;
		  
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'te' + CAST(@worksheet_counter AS VARCHAR(2))
			SELECT @worksheet_counter = @worksheet_counter + 1;   
			
			SELECT @sql = 'alter table #ig add ' + @column + ' int null default 0';
			--PRINT @sql
			EXEC (@sql);
		END;
		      
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'te' + CAST(@worksheet_counter AS VARCHAR(2));      
			
			SELECT @sql = 'update a set ' + @column + ' = (select expense_total from ig_Worksheet_CashRcpts where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS VARCHAR(2)) + ') from #ig a'
			--PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;      
		END;
	
	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'projcash' + CAST(@worksheet_counter AS VARCHAR(2));
			SELECT @worksheet_counter = @worksheet_counter + 1;

			SELECT @sql = 'alter table #ig add ' + @column + ' int null default 0';
			-- PRINT @sql
			EXEC (@sql)
		END;

	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'projcash' + CAST(@worksheet_counter AS VARCHAR(2));

			SELECT @sql = 'update a set ' + @column + ' = (select cash_amount from ig_Worksheet_RiskCriteria where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS varchar(2)) + ') from #ig a';
			-- PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;
		END;

	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'netcheck' + CAST(@worksheet_counter AS VARCHAR(2));
			SELECT @worksheet_counter = @worksheet_counter + 1;

			SELECT @sql = 'alter table #ig add ' + @column + ' int null default 0';
			-- PRINT @sql
			EXEC (@sql)
		END;

	SELECT @worksheet_counter = 1;

	WHILE @worksheet_counter <= @worksheet_total
		BEGIN
			SELECT @column = 'netcheck' + CAST(@worksheet_counter AS VARCHAR(2));

			SELECT @sql = 'update a set ' + @column + ' = (select net_chk_amt_due_to_phys from ig_Worksheet_CashRcpts where worksheet_id = a.worksheet_id and month = ' + CAST(@worksheet_counter AS varchar(2)) + ') from #ig a';
			-- PRINT @sql
			EXEC (@sql);

			SELECT @worksheet_counter = @worksheet_counter + 1;
		END;

	SELECT *
	FROM #ig
	ORDER BY facility, last_name, first_name
END

