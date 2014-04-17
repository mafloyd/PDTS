


-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/21/2011
-- Description:	Get COID admits by QTD
-- =============================================
CREATE PROCEDURE [dbo].[GetCOIDAdmitsQTD] 
    (
        @year int,
        @month int,
		@quarter int
    )
AS
BEGIN
    declare @pdts_provider_id int;
    declare @note varchar(1000);
    
	if @quarter = 1
		begin
			select p.coid, c.name, sum(b.admits) as admits
			from provider p
				join currentyear_admit b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 1
						and b.monthno <= @month
                
				join facility c 
					on p.coid = c.coid
			group by p.coid, c.name
			order by c.name
		end
	else if @quarter = 2
		begin
			select p.coid, c.name, sum(b.admits) as admits
			from provider p
				join currentyear_admit b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 4
						and b.monthno <= @month
                
				join facility c 
					on p.coid = c.coid
			group by p.coid, c.name
			order by c.name
		end
	else if @quarter = 3
		begin
			select p.coid, c.name, sum(b.admits) as admits
			from provider p
				join currentyear_admit b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 7
						and b.monthno <= @month
                
				join facility c 
					on p.coid = c.coid
			group by p.coid, c.name
			order by c.name
		end
	else if @quarter = 4
		begin
			select p.coid, c.name, sum(b.admits) as admits
			from provider p
				join currentyear_admit b
					on p.pdts_provider_id = b.pdts_provider_id
						and b.year = @year
						and b.monthno >= 10
						and b.monthno <= @month
                
				join facility c 
					on p.coid = c.coid
			group by p.coid, c.name
			order by c.name
		end
END

