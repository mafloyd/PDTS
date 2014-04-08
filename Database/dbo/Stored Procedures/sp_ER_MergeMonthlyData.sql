CREATE PROCEDURE [dbo].[sp_ER_MergeMonthlyData]
AS
BEGIN
	DECLARE @coid VARCHAR(5)
	DECLARE @year_of_discharge_date INT
	DECLARE @month_of_discharge_date INT
	  
	SET NOCOUNT ON;
	
	-- first step is to get rid of the data in the ER_MONTHLY_DATA table
	DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT DISTINCT coid, year_of_discharge_date, month_of_discharge_date  
	FROM dbo.ER_MONTHLY_DATA_STAGE

	OPEN cur

	FETCH NEXT FROM cur
	INTO @coid, @year_of_discharge_date, @month_of_discharge_date

	WHILE @@fetch_status = 0
		BEGIN
			DELETE
			FROM dbo.ER_MONTHLY_DATA
			WHERE coid = @coid
				AND year_of_discharge_date = @year_of_discharge_date
				AND MONTH_OF_DISCHARGE_DATE = @month_of_discharge_date;
				      
			FETCH NEXT FROM cur
			INTO @coid, @year_of_discharge_date, @month_of_discharge_date      
		END
		
	CLOSE cur
	DEALLOCATE cur    
	
	-- now insert unique encounters to ER_MONTHLY_DATA
	INSERT INTO dbo.ER_MONTHLY_DATA
	        ( COID ,
	          YEAR_OF_DISCHARGE_DATE ,
	          MONTH_OF_DISCHARGE_DATE ,
	          FINANCIAL_CLASS_ID ,
	          PAT_TYPE ,
	          PAT_TYPE_POS1 ,
	          PAT_NUM ,
	          PAT_BIRTH_DATE ,
	          AGE ,
	          ADMIT_TIME ,
	          NUMBER_OF_CASES ,
	          OBSERVATION
	        )
	SELECT DISTINCT
		COID ,
	    YEAR_OF_DISCHARGE_DATE ,
	    MONTH_OF_DISCHARGE_DATE ,
	    FINANCIAL_CLASS_ID ,
	    PAT_TYPE ,
	    PAT_TYPE_POS1 ,
	    PAT_NUM ,
	    PAT_BIRTH_DATE ,
	    AGE ,
	    ADMIT_TIME ,
	    NUMBER_OF_CASES ,
	    OBSERVATION  
	FROM dbo.ER_MONTHLY_DATA_STAGE

	-- now insert details into ER_MONTHLY_DATA_DETAIL
	INSERT INTO dbo.ER_MONTHLY_DATA_DETAIL
	        ( ER_DATA_ID ,
	          CHARGE_CPT_CODE ,
	          CHARGE_REV_CODE ,
	          SUM_OF_TOTAL_CASH_PYMT ,
	          SUM_OF_CHRG_AMT ,
	          SUM_OF_CHRG_FACTORS,
			  CHARGE_HCPCS_PROC
	        )
	SELECT
		b.er_data_id,
		a.CHARGE_CPT_CODE,
		a.CHARGE_REV_CODE,
		a.SUM_OF_TOTAL_CASH_PYMT,
		a.SUM_OF_CHRG_AMT,
		a.SUM_OF_CHRG_FACTORS,
		a.CHARGE_HCPCS_PROC
	FROM dbo.ER_MONTHLY_DATA_STAGE a WITH (NOLOCK)
		JOIN dbo.ER_MONTHLY_DATA b WITH (NOLOCK)
			ON a.coid = b.COID
				AND a.YEAR_OF_DISCHARGE_DATE = b.YEAR_OF_DISCHARGE_DATE
				AND a.MONTH_OF_DISCHARGE_DATE = b.MONTH_OF_DISCHARGE_DATE
				AND a.PAT_NUM = b.pat_num

	-- now set observation bit
	UPDATE a
	SET observation = 1
	FROM ER_MONTHLY_DATA a
	WHERE EXISTS
		(
			SELECT 1
			FROM dbo.ER_MONTHLY_DATA b WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL c WITH (NOLOCK)
					ON b.ER_DATA_ID = c.ER_DATA_ID
						AND ((c.CHARGE_REV_CODE BETWEEN 450 AND 459) OR (c.CHARGE_REV_CODE BETWEEN 680 AND 689))

				JOIN dbo.ER_MONTHLY_DATA_DETAIL d WITH (NOLOCK)
					ON b.ER_DATA_ID = d.ER_DATA_ID
						AND d.CHARGE_REV_CODE = 762
			WHERE b.er_data_id = a.er_data_id
		);
END

