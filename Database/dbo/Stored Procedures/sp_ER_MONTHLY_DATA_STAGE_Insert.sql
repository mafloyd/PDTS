CREATE PROCEDURE [dbo].[sp_ER_MONTHLY_DATA_STAGE_Insert]
	(
		@coid VARCHAR(5),
		@year_of_discharge_date INT,
		@month_of_discharge_date INT,
		@financial_class_id INT,
		@pat_type VARCHAR(5),
		@pat_type_pos1 VARCHAR(1),
		@charge_cpt_code VARCHAR(5),
		@charge_rev_code INT,
		@pat_num VARCHAR(50),
		@pat_birth_date DATETIME,
		@age INT,
		@admit_time INT,
		@number_of_cases INT,
		@sum_of_total_cash_pymt DECIMAL(18, 2),
		@sum_of_chrg_amt DECIMAL(18, 2),
		@sum_of_chrg_factors INT,
		@charge_hcpcs_proc VARCHAR(6)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT @financial_class_id = financial_class_id 
	FROM dbo.MASTER_FINANCIAL_CLASS WITH (NOLOCK)
	WHERE FINANCIAL_CLASS = @financial_class_id;
	
    INSERT INTO ER_MONTHLY_DATA_STAGE
		(
			COID,
			YEAR_OF_DISCHARGE_DATE,
			MONTH_OF_DISCHARGE_DATE,
			FINANCIAL_CLASS_ID,
			PAT_TYPE,
			PAT_TYPE_POS1,
			CHARGE_CPT_CODE,
			CHARGE_REV_CODE,
			PAT_NUM,
			PAT_BIRTH_DATE,
			AGE,
			ADMIT_TIME,
			NUMBER_OF_CASES,
			SUM_OF_TOTAL_CASH_PYMT,
			SUM_OF_CHRG_AMT,
			SUM_OF_CHRG_FACTORS,
			CHARGE_HCPCS_PROC
		)
	VALUES
		(
			@coid,
			@year_of_discharge_date,
			@month_of_discharge_date,
			@financial_class_id,
			@pat_type,
			@pat_type_pos1,
			@charge_cpt_code,
			@charge_rev_code,
			@pat_num,
			@pat_birth_date,
			@age,
			@admit_time,
			@number_of_cases,
			@sum_of_total_cash_pymt,
			@sum_of_chrg_amt,
			@sum_of_chrg_factors,
			@charge_hcpcs_proc
		);
		
	--EXECUTE dbo.sp_ER_DATA_STAGE_Cleanup;
END;

