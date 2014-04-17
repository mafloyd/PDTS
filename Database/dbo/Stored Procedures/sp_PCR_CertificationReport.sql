CREATE PROCEDURE [dbo].[sp_PCR_CertificationReport]
	(
		@month INT,
		@year INT,
		@prePost VARCHAR(4)
	)
AS
BEGIN	  
	SET NOCOUNT ON;

	DECLARE @t TABLE
		(
			division varchar(50),
			coid varchar(5),
			facility varchar(50),
			user_title varchar(50),
			approver_name varchar(100),
			approve varchar(10),
			comment varchar(500),
			approval_date DATETIME,
			sort_order TINYINT
		);

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

	INSERT INTO @t
	        ( division ,
	          coid ,
	          facility ,
	          user_title ,
	          approver_name ,
	          approve ,
	          comment ,
	          approval_date,
			  sort_order
	        )
	SELECT 
		d.NAME, 
		a.coid, 
		f.name, 
		'Controller',
		a.CONTROLLER, 
		a.CONTROLLER_CERTIFIED,
		a.CONTROLLER_COMMENTS,
		a.CONTROLLER_CERT_DATE,
		10
	FROM dbo.PCR_CERTIFICATION a WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON a.COID = f.COID
		
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID  
	WHERE month = @month
		AND year = @year
		AND is_pre = 0
		AND is_post = 1

	INSERT INTO @t
	        ( division ,
	          coid ,
	          facility ,
	          user_title ,
	          approver_name ,
	          approve ,
	          comment ,
	          approval_date,
			  sort_order
	        )
	SELECT 
		d.NAME, 
		a.coid, 
		f.name, 
		'CFO',
		a.CFO, 
		a.CFO_CERTIFIED,
		a.CFO_COMMENTS,
		a.CFO_CERT_DATE,
		20
	FROM dbo.PCR_CERTIFICATION a WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON a.COID = f.COID
		
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID  
	WHERE month = @month
		AND year = @year
		AND is_pre = 0
		AND is_post = 1

	INSERT INTO @t
	        ( division ,
	          coid ,
	          facility ,
	          user_title ,
	          approver_name ,
	          approve ,
	          comment ,
	          approval_date,
			  sort_order
	        )
	SELECT 
		d.NAME, 
		a.coid, 
		f.name, 
		'CEO',
		a.CEO, 
		a.CEO_CERTIFIED,
		a.CEO_COMMENTS,
		a.CEO_CERT_DATE,
		30
	FROM dbo.PCR_CERTIFICATION a WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON a.COID = f.COID
		
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID  
	WHERE month = @month
		AND year = @year
		AND is_pre = 0
		AND is_post = 1

	INSERT INTO @t
	        ( division ,
	          coid ,
	          facility ,
	          user_title ,
	          approver_name ,
	          approve ,
	          comment ,
	          approval_date,
			  sort_order
	        )
	SELECT 
		d.NAME, 
		a.coid, 
		f.name, 
		'Group Controller',
		a.DIVISION_CONTROLLER, 
		a.DIVISION_CONTROLLER_CERTIFIED,
		a.DIVISION_CONTROLLER_COMMENTS,
		a.DIVISION_CONTROLLER_CERT_DATE,
		40
	FROM dbo.PCR_CERTIFICATION a WITH (NOLOCK)
		JOIN dbo.Facility f WITH (NOLOCK)
			ON a.COID = f.COID
		
		JOIN dbo.Division d WITH (NOLOCK)
			ON f.DIVISION_ID = d.DIVISION_ID  
	WHERE month = @month
		AND year = @year
		AND is_pre = 0
		AND is_post = 1

	SELECT *
	FROM @t
	ORDER BY division, facility, sort_order
END

