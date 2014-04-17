CREATE PROCEDURE [dbo].[sp_Report_MaterialDocs]
	@material_doc BIT = 0,
	@year INT = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @year = 0
		BEGIN
			RETURN;
		END;
		
    SELECT 
		d.NAME AS division, 
		f.coid, 
		f.name AS facility, 
		p.last_name, 
		p.first_name, 
		s.LONG_NAME AS specialty, 
		pr.LONG_NAME AS left_reason, 
		p.OTHER_REASON_TEXT,
		CONVERT(VARCHAR(10), p.start_date, 101) AS START_DATE,
		CONVERT(VARCHAR(10), p.LEFT_DATE, 101) AS left_date,
		mpr.name AS material_reason
    FROM provider p WITH (NOLOCK)
		JOIN facility f WITH (NOLOCK)
			ON p.coid = f.COID
			
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID
			
		LEFT JOIN dbo.Specialty s WITH (NOLOCK)
			ON p.SPECIALTY_ID = s.SPECIALTY_ID
			
		LEFT JOIN dbo.Physician_Reason pr WITH (NOLOCK)
			ON p.PHYSICIAN_REASON_ID = pr.PHYSICIAN_REASON_ID
			
		LEFT JOIN dbo.Material_Physician_Reason mpr
			ON p.MATERIAL_PHYSICIAN_REASON_ID = mpr.material_physician_reason_id
    WHERE p.MATERIAL_DOC = @material_doc
		AND p.LEFT_DATE IS NOT NULL
		AND DATEPART(yyyy, p.left_date) = @year
END

