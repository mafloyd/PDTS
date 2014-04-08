


-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/21/2011
-- Description:	Get COID Surgeries by QTD
-- =============================================
CREATE PROCEDURE [dbo].[GetCOIDSurgeriesQTD] 
    (
        @year int,
        @month int,
		@quarter int
    )
AS
BEGIN
	if @quarter = 1
		begin
			select p.coid, c.name, sum(b.inpatient) as inpatient, sum(b.outpatient) as outpatient, b.surgical_type_id, st.short_name
			from provider p
				join currentyear_surgery b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 1
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
		end
	else if @quarter = 2
		begin
			select p.coid, c.name, sum(b.inpatient) as inpatient, sum(b.outpatient) as outpatient, b.surgical_type_id, st.short_name
			from provider p
				join currentyear_surgery b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 4
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
		end
	else if @quarter = 3
		begin
			select p.coid, c.name, sum(b.inpatient) as inpatient, sum(b.outpatient) as outpatient, b.surgical_type_id, st.short_name
			from provider p
				join currentyear_surgery b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 7
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
		end
	else if @quarter = 4
		begin
			select p.coid, c.name, sum(b.inpatient) as inpatient, sum(b.outpatient) as outpatient, b.surgical_type_id, st.short_name
			from provider p
				join currentyear_surgery b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 10
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
		end
END

