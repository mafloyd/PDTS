create PROCEDURE [dbo].[sp_GetThreeYearSurgicalTotalsBySurgicalType]
	(
	    @coid varchar(5),
	    @startYear int,
	    @endYear int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
        a.pdts_provider_id,
        b.surgical_type_id,
        sum(b.inpatient) as inpatient
    from provider a
        join currentyear_surgery b
            on a.pdts_provider_id = b.pdts_provider_id
                and b.year >= @startYear
                and b.year <= @endYear
    where a.coid = @coid
    group by a.pdts_provider_id, b.surgical_type_id
	
END

