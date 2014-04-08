CREATE PROCEDURE [dbo].[sp_report_ERDivisionRollup_FacilityList]
	(
		@division_id int,
		@year int,
		@month INT,
		@edm_managing_company_id INT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @results TABLE
		(
			coid VARCHAR(5),
			NAME VARCHAR(50),
			total_ed_visits INT,
			edm_managing_company_id INT,
			division_id int
		)  

	INSERT INTO @results (coid, name, total_ed_visits, edm_managing_company_id, division_id)
    SELECT DISTINCT 
		b.coid,
		b.name,
		CASE COUNT(b.name) 
			WHEN 1 THEN 0
			ELSE COUNT(b.NAME)
		END AS total_ed_visits,
		ISNULL(b.EDM_MANAGING_COMPANY_ID, 0),
		b.DIVISION_ID
	FROM facility b WITH (NOLOCK)
		join dbo.DIVISION d with (nolock)
			on b.division_id = d.division_id

		LEFT JOIN dbo.ER_MONTHLY_DATA erm WITH (NOLOCK)
			ON b.coid = erm.COID
				AND erm.YEAR_OF_DISCHARGE_DATE = @year
				AND erm.MONTH_OF_DISCHARGE_DATE = @month
	WHERE b.SHOW_IN_DETAIL_REPORTS = 1
	GROUP BY b.coid, b.name, b.EDM_MANAGING_COMPANY_ID, b.DIVISION_ID
	
	IF @division_id > 1
		BEGIN
			DELETE
			FROM @results
			WHERE division_id <> @division_id      
		END;      

	IF @edm_managing_company_id > 0
		BEGIN
			DELETE
			FROM @results
			WHERE ISNULL(edm_managing_company_id, 0) <> @edm_managing_company_id      
		END;
		      
	SELECT *
	FROM @results
	ORDER BY name;
END

