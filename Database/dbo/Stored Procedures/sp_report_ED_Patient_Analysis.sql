CREATE PROCEDURE [dbo].[sp_report_ED_Patient_Analysis]
	(
		@coid VARCHAR(5),
		@year INT,
		@month int
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @t TABLE
		(
			coid VARCHAR(5),
			cy_ed_admits INT,
			py_ed_admits INT,
			cy_ed_visits INT,
			py_ed_visits INT,
			cytd_ed_admits INT,
			pytd_ed_admits INT,
			cy_ed_obs INT,
			py_ed_obs INT,
			cytd_visits INT,
			pytd_visits INT,
			cytd_ed_obs INT,
			pytd_ed_obs INT,
			cy_payments DECIMAL (18, 2),
			py_payments DECIMAL(18, 2),
			cytd_payments DECIMAL(18, 2),
			pytd_payments DECIMAL (18, 2),
			cy_gero_admits INT,
			py_gero_admits INT,
			cytd_gero_admits INT,
			pytd_gero_admits INT,
			cy_gero_visits INT,
			py_gero_visits INT,
			cytd_gero_visits INT,
			pytd_gero_visits INT
		)
		
	DECLARE @payments TABLE
		(
			er_data_id INT,
			sum_of_total_cash_pymt DECIMAL(18, 2)
		);  

	INSERT INTO @t (coid)
	VALUES (@coid);
	
	UPDATE @t
	SET cy_ed_admits = 
		(
			SELECT COUNT(1) 
			FROM ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE COID = @coid
				AND YEAR_OF_DISCHARGE_DATE = @year 
				AND MONTH_OF_DISCHARGE_DATE = @month 
				AND PAT_TYPE_POS1 = 'I'
		);
		
	UPDATE @t
	SET py_ed_admits =
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND MONTH_OF_DISCHARGE_DATE = @month
				AND PAT_TYPE_POS1 = 'I'
		);
		
	UPDATE @t
	SET cy_ed_visits = 
		(
			SELECT total
			FROM dbo.ER_DAILY_ENTRY WITH (NOLOCK)
			WHERE coid = @coid
				AND ER_DAILY_STATS_DEFINITION_ID = 15
				AND MONTH = @month
				AND YEAR = @year
		);
		
	UPDATE @t
	SET py_ed_visits =
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND MONTH_OF_DISCHARGE_DATE = @month
		);

	UPDATE @t
	SET cytd_ed_admits = 
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = @year
				AND MONTH_OF_DISCHARGE_DATE <= @month
				AND pat_type_pos1 = 'I'
		)		
	
	UPDATE @t
	SET pytd_ed_admits = 
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND MONTH_OF_DISCHARGE_DATE <= @month
				AND pat_type_pos1 = 'I'
		)

	UPDATE @t
	SET cy_ed_obs = 
		(
			SELECT count(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.ER_DATA_ID = b.ER_DATA_ID
						AND b.CHARGE_REV_CODE BETWEEN 450 AND 459

				JOIN dbo.ER_MONTHLY_DATA_DETAIL c WITH (NOLOCK)
					ON a.ER_DATA_ID = c.ER_DATA_ID
						AND c.CHARGE_REV_CODE = 762
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE = @month
		)

	UPDATE @t
	SET py_ed_obs = 
		(
			SELECT count(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.ER_DATA_ID = b.ER_DATA_ID
						AND b.CHARGE_REV_CODE BETWEEN 450 AND 459

				JOIN dbo.ER_MONTHLY_DATA_DETAIL c WITH (NOLOCK)
					ON a.ER_DATA_ID = c.ER_DATA_ID
						AND c.CHARGE_REV_CODE = 762
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE = @month
		)

	UPDATE @t
	SET cytd_visits = 
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = @year
				AND MONTH_OF_DISCHARGE_DATE <= @month
		)

	UPDATE @t
	SET pytd_visits = 
		(
			SELECT COUNT(1)
			FROM dbo.ER_MONTHLY_DATA WITH (NOLOCK)
			WHERE coid = @coid
				AND YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND MONTH_OF_DISCHARGE_DATE <= @month
		)

	UPDATE @t
	SET cytd_ed_obs =
		(
			SELECT count(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.ER_DATA_ID = b.ER_DATA_ID
						AND b.CHARGE_REV_CODE BETWEEN 450 AND 459

				JOIN dbo.ER_MONTHLY_DATA_DETAIL c WITH (NOLOCK)
					ON a.ER_DATA_ID = c.ER_DATA_ID
						AND c.CHARGE_REV_CODE = 762
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE <= @month
		)

	UPDATE @t
	SET pytd_ed_obs = 
		(
			SELECT count(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.ER_DATA_ID = b.ER_DATA_ID
						AND b.CHARGE_REV_CODE BETWEEN 450 AND 459

				JOIN dbo.ER_MONTHLY_DATA_DETAIL c WITH (NOLOCK)
					ON a.ER_DATA_ID = c.ER_DATA_ID
						AND c.CHARGE_REV_CODE = 762
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE <= @month
		)

	UPDATE @t
	SET cy_gero_admits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE = @month 
				AND a.PAT_TYPE_POS1 = 'I'
				AND a.AGE > 65
		)

	UPDATE @t
	SET py_gero_admits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE = @month 
				AND a.PAT_TYPE_POS1 = 'I'
				AND a.AGE > 65
		)

	UPDATE @t
	SET cytd_gero_admits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE <= @month 
				AND a.PAT_TYPE_POS1 = 'I'
				AND a.AGE > 65
		)

	UPDATE @t
	SET pytd_gero_admits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE <= @month 
				AND a.PAT_TYPE_POS1 = 'I'
				AND a.AGE > 65
		)

	UPDATE @t
	SET cy_gero_visits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE = @month 
				AND a.AGE > 65
		)

	UPDATE @t
	SET py_gero_visits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE = @month 
				AND a.AGE > 65
		)

	UPDATE @t
	SET cytd_gero_visits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = @year
				AND a.MONTH_OF_DISCHARGE_DATE <= @month 
				AND a.AGE > 65
		)

	UPDATE @t
	SET pytd_gero_visits = 
		(
			SELECT COUNT(DISTINCT a.PAT_NUM)
			FROM dbo.ER_MONTHLY_DATA a WITH (NOLOCK)
				JOIN dbo.ER_MONTHLY_DATA_DETAIL b WITH (NOLOCK)
					ON a.er_data_id = b.ER_DATA_ID
			WHERE a.coid = @coid
				AND a.YEAR_OF_DISCHARGE_DATE = (@year - 1)
				AND a.MONTH_OF_DISCHARGE_DATE <= @month 
				AND a.AGE > 65
		)

	SELECT *
	FROM @t;
END


