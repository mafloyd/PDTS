
CREATE PROCEDURE [dbo].[sp_PCR_ControlChecklistCertificationReport]
	(
		@month INT,
		@year INT,
		@prePost VARCHAR(4)
	)
AS
BEGIN	  
	SET NOCOUNT ON;

	DECLARE @pre BIT;
	DECLARE @post BIT;

    IF UPPER(@prePost) != 'PRE' AND UPPER(@prePost) != 'POST'
		BEGIN
			RETURN;      
		END;      

	IF UPPER(@prePost) = 'PRE'
		BEGIN
			SELECT @pre = 1;
			SELECT @post = 0;
		END
	ELSE IF UPPER(@prePost) = 'POST'
		BEGIN
			SELECT @pre = 0;
			SELECT @post = 1;
		END;      

	IF @month IN (1, 2, 4, 5, 7, 8, 10, 11)
		BEGIN
			SELECT 
				d.name AS groupName, 
				f.coid,
				f.NAME,
				ma.CONTROL,
				fma.VALIDATE_USER_NAME,
				fma.validate_user_date,
				fma.REVIEWED_USER_NAME,
				fma.reviewed_user_name,
				fma.COMMENT
			FROM Facility f WITH (NOLOCK)
				JOIN dbo.Division d WITH (NOLOCK)
					ON f.DIVISION_ID = d.DIVISION_ID

				LEFT JOIN dbo.FACILITY_MONTHLY_AUDIT fma WITH (NOLOCK)
					ON f.coid = fma.coid

				LEFT JOIN dbo.MASTER_AUDIT ma WITH (NOLOCK)
					ON fma.AUDIT_ID = ma.AUDIT_ID
						AND fma.month = @month
						AND fma.year = @year
			WHERE f.DIVISION_ID IN (7, 8, 9)
			ORDER BY d.name, f.name, ma.control_id;
		END;      
END


