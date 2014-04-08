


-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/21/2011
-- Description:	Get COID Surgeries by YTD
-- =============================================
CREATE PROCEDURE [dbo].[GetCOIDSurgeriesYTD] 
    (
        @year int,
        @month int
    )
AS
BEGIN
	select p.coid, c.name, sum(b.inpatient) as inpatient, sum(b.outpatient) as outpatient, b.surgical_type_id, st.short_name
	from provider p
		left join currentyear_surgery b
			on p.pdts_provider_id = b.pdts_provider_id
				and b.year = @year
				and b.monthno <= @month
                
		join facility c 
			on p.coid = c.coid

		left join surgical_type st
			on b.surgical_type_id = st.surgical_type_id

		join canary.dbo.tblFacility f
			on p.coid = f.coid
				and f.lob = 'HOS'
	group by p.coid, c.name, b.surgical_type_id, st.short_name
	order by c.name
END

