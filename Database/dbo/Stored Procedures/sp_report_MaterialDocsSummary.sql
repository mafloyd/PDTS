﻿CREATE PROCEDURE [dbo].[sp_report_MaterialDocsSummary]
	@material BIT = 0,
	@throughDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @summary TABLE
		(
			measure VARCHAR(25),
			measure_count int
		)
		
	-- get summary by specialty first
	INSERT INTO @summary (measure, measure_count)
	SELECT s.LONG_NAME, COUNT(s.LONG_NAME)
	FROM dbo.Provider p WITH (NOLOCK)
		JOIN dbo.Specialty s WITH (NOLOCK)
			ON p.SPECIALTY_ID = s.SPECIALTY_ID
	WHERE p.MATERIAL_DOC = @material
		AND p.LEFT_DATE IS NOT NULL
		AND DATEPART(yyyy, p.left_date) = DATEPART(yyyy, @throughDate)
		AND p.LEFT_DATE <= @throughDate
	GROUP BY s.LONG_NAME
	ORDER BY s.LONG_NAME;
	
	-- get summary by material reason second
	INSERT INTO @summary (measure, measure_count)
	SELECT mpr.name, COUNT(mpr.name)
	FROM dbo.Provider p WITH (NOLOCK)
		JOIN dbo.Material_Physician_Reason mpr WITH (NOLOCK)
			ON p.MATERIAL_PHYSICIAN_REASON_ID = mpr.material_physician_reason_id
	WHERE p.MATERIAL_DOC = @material
		AND p.LEFT_DATE IS NOT NULL
		AND DATEPART(yyyy, p.left_date) = DATEPART(yyyy, @throughDate)
		AND p.LEFT_DATE <= @throughDate
	GROUP BY mpr.name
	ORDER BY mpr.name;
	
	SELECT *
	FROM @summary;
END

