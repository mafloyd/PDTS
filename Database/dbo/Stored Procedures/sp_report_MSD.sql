CREATE PROCEDURE [dbo].[sp_report_MSD]
	(
		@coid VARCHAR(5)
	)
AS
begin
	DECLARE @t TABLE
		(
			pdts_provider_id INT,
			facility VARCHAR(50),
			specialty_group VARCHAR(50),
			specialty VARCHAR(50),
			last_name VARCHAR(50),
			first_name VARCHAR(50),
			middle_name VARCHAR(50),
			fte_assessment DECIMAL(5, 2),
			dob DATETIME,
			provider_affiliation VARCHAR(50),
			community_acceptance VARCHAR(50),
			other_risk VARCHAR(50),
			practice_revenues VARCHAR(50),
			years_in_practice VARCHAR(50),
			specialty_group_sort_order TINYINT,
			midlevel_count INT,
			risk_score DECIMAL(5, 2)
		);

	INSERT INTO @t
		(
			pdts_provider_id,
			facility,
			specialty_group,
			specialty,
			last_name,
			first_name,
			middle_name,
			fte_assessment,
			dob,
			provider_affiliation,
			community_acceptance,
			other_risk,
			practice_revenues,
			years_in_practice,
			specialty_group_sort_order,
			risk_score
		)
	SELECT 
		p.PDTS_PROVIDER_ID,
		f.NAME,
		sgtl.name AS specialty_group,
		s.long_name AS specialty,
		ISNULL(p.last_name, ''),
		ISNULL(p.first_name, ''),
		ISNULL(p.middle_name, ''),
		p.FTE_ASSESSMENT,
		p.DOB,
		pa.name AS provider_affiliation,
		pcca.name AS community_acceptance,
		pcor.name AS other_risk,
		pccr.name AS practice_revenues,
		pcyp.name AS years_in_practice,
		sgtl.SORT_ORDER,
		p.risk_score
	FROM Facility f WITH (NOLOCK)
		JOIN Provider p WITH (NOLOCK) 
			ON f.coid = p.coid

		JOIN Specialty s WITH (NOLOCK)
			ON p.SPECIALTY_ID = s.SPECIALTY_ID

		JOIN dbo.SPECIALTY_GROUP_TOP_LEVEL sgtl WITH (NOLOCK)
			ON s.SPECIALTY_GROP_TOP_LEVEL_ID = sgtl.SPECIALTY_GROUP_TOP_LEVEL_ID

		JOIN dbo.PROVIDER_AFFILIATION pa WITH (NOLOCK)
			ON p.PROVIDER_AFFILIATION_ID = pa.PROVIDER_AFFILIATION_ID

		LEFT JOIN dbo.PRIMARY_CARE_COMMUNITY_ACCEPTANCE pcca WITH (NOLOCK)
			ON p.PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID = pcca.PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID

		LEFT JOIN dbo.PRIMARY_CARE_OTHER_RISK pcor WITH (NOLOCK)
			ON p.PRIMARY_CARE_OTHER_RISK_ID = pcor.PRIMARY_CARE_OTHER_RISK_ID

		LEFT JOIN dbo.PRIMARY_CARE_PRACTICE_REVENUE pccr WITH (NOLOCK)
			ON p.PRIMARY_CARE_PRACTICE_REVENUE_ID = pccr.PRIMARY_CARE_PRACTICE_REVENUE_ID

		LEFT JOIN dbo.PRIMARY_CARE_YEARS_IN_PRACTICE pcyp WITH (NOLOCK)
			ON p.PRIMARY_CARE_YEARS_IN_PRACTICE_ID = pcyp.PRIMARY_CARE_YEARS_IN_PRACTICE_ID
	WHERE f.coid = @coid
		AND p.PROVIDER_AFFILIATION_ID IN (1, 2)
		AND ISNULL(p.PROVIDER_POSITION_STATUS_ID, 0) NOT IN (4)
		AND p.LEFT_DATE IS null
	ORDER BY sgtl.name, s.long_name, p.last_name, p.first_name, p.MIDDLE_NAME;

	UPDATE a
	SET midlevel_count = 
		(
			SELECT COUNT(1)
			FROM Provider WITH (NOLOCK)
			WHERE RESPONSIBLE_PDTS_PROVIDER_ID = a.pdts_provider_id
		)
	FROM @t a;

	SELECT *
	FROM @t
	ORDER BY specialty_group_sort_order, specialty, last_name, first_name, middle_name
END;

