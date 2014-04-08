CREATE PROCEDURE [dbo].[sp_report_SurgeriesByMonth] 
	(
		@coid VARCHAR(5),
		@year INT,
		@inorout VARCHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		a.coid, 
		a.provider_id, 
		a.last_name, 
		a.first_name, 
		a.MIDDLE_NAME, 
		s.long_name AS specialty,
		b.year, 
		b.MONTHNO,
		st.SURGICAL_TYPE_ID,
		st.LONG_NAME AS surgical_type,
		CASE @inorout
			WHEN 'I' THEN b.INPATIENT
			WHEN 'O' THEN b.outpatient
		END AS surgery_count
	FROM Provider a WITH (NOLOCK)
		JOIN dbo.CurrentYear_Surgery b WITH (NOLOCK)
			ON a.PDTS_PROVIDER_ID = b.PDTS_PROVIDER_ID
			
		JOIN dbo.Specialty s WITH (NOLOCK)
			ON a.SPECIALTY_ID = s.SPECIALTY_ID
			
		LEFT JOIN dbo.Surgical_Type st
			ON b.SURGICAL_TYPE_ID = st.SURGICAL_TYPE_ID
	WHERE a.coid = @coid
		AND b.year = @year
	ORDER BY a.coid, a.last_name, a.first_name, a.MIDDLE_NAME, b.year, b.MONTHNO, st.SURGICAL_TYPE_ID
END

