CREATE PROCEDURE [dbo].[sp_report_ED_Patient_Analysis_VisitsByFinClass]
	(
		@coid VARCHAR(5),
		@year INT,
		@month INT,
		@financial_class_ids VARCHAR(10)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(4000);
	DECLARE @yearMinusOne INT;

    DECLARE @t TABLE
		(
			coid VARCHAR(5),
			cm DECIMAL(18, 2),
			cm_py DECIMAL(18, 2),
			ytd DECIMAL(18, 2),
			ytd_py DECIMAL(18, 2)
		); 

	IF object_id('tempdb..#t') IS NOT NULL	
		BEGIN
			DROP TABLE #t;      
		END;      

	CREATE TABLE #t
	(
		coid VARCHAR(5),
		cm DECIMAL(18, 2),
		cm_py DECIMAL(18, 2),
		ytd DECIMAL(18, 2),
		ytd_py DECIMAL(18, 2)
	); 

	INSERT INTO #t (coid)
	VALUES  (@coid);

	SELECT @yearMinusOne = @year - 1;

	SELECT @sql = 'update #t ';
	SELECT @sql = @sql + 'set cm = ';
	SELECT @sql = @sql + '( '
	SELECT @sql = @sql + 'select count(er_data_id) '
	SELECT @sql = @sql + 'from er_monthly_data with (nolock) '
	SELECT @sql = @sql + 'where coid = ''' + @coid + ''' ';
	SELECT @sql = @sql + 'and year_of_discharge_date = ' + CAST(@year AS VARCHAR(4)) + ' ';
	SELECT @sql = @sql + 'and month_of_discharge_date = ' + CAST(@month AS VARCHAR(2)) +  ' ';
	SELECT @sql = @sql + 'and financial_class_id in (' + @financial_class_ids + ') ';		
	SELECT @sql = @sql + ') ';
		
	EXEC (@sql);
		
	SELECT @sql = 'update #t ';
	SELECT @sql = @sql + 'set cm_py = ';
	SELECT @sql = @sql + '( '
	SELECT @sql = @sql + 'select count(er_data_id) '
	SELECT @sql = @sql + 'from er_monthly_data with (nolock) '
	SELECT @sql = @sql + 'where coid = ''' + @coid + ''' ';
	SELECT @sql = @sql + 'and year_of_discharge_date = ' + CAST(@yearMinusOne AS VARCHAR(4)) + ' ';
	SELECT @sql = @sql + 'and month_of_discharge_date = ' + CAST(@month AS VARCHAR(2)) +  ' ';
	SELECT @sql = @sql + 'and financial_class_id in (' + @financial_class_ids + ') ';		
	SELECT @sql = @sql + ') ';

	EXEC (@sql);

	SELECT @sql = 'update #t ';
	SELECT @sql = @sql + 'set ytd = ';
	SELECT @sql = @sql + '( '
	SELECT @sql = @sql + 'select count(er_data_id) '
	SELECT @sql = @sql + 'from er_monthly_data with (nolock) '
	SELECT @sql = @sql + 'where coid = ''' + @coid + ''' ';
	SELECT @sql = @sql + 'and year_of_discharge_date = ' + CAST(@year AS VARCHAR(4)) + ' ';
	SELECT @sql = @sql + 'and month_of_discharge_date <= ' + CAST(@month AS VARCHAR(2)) +  ' ';
	SELECT @sql = @sql + 'and financial_class_id in (' + @financial_class_ids + ') ';		
	SELECT @sql = @sql + ') ';

	EXEC (@sql);

	SELECT @sql = 'update #t ';
	SELECT @sql = @sql + 'set ytd_py = ';
	SELECT @sql = @sql + '( '
	SELECT @sql = @sql + 'select count(er_data_id) '
	SELECT @sql = @sql + 'from er_monthly_data with (nolock) '
	SELECT @sql = @sql + 'where coid = ''' + @coid + ''' ';
	SELECT @sql = @sql + 'and year_of_discharge_date = ' + CAST(@yearMinusOne AS VARCHAR(4)) + ' ';
	SELECT @sql = @sql + 'and month_of_discharge_date <= ' + CAST(@month AS VARCHAR(2)) +  ' ';
	SELECT @sql = @sql + 'and financial_class_id in (' + @financial_class_ids + ') ';		
	SELECT @sql = @sql + ') ';

	EXEC (@sql);

	INSERT INTO @t
	SELECT *
	FROM #t;

	SELECT *
	FROM @t;
END

