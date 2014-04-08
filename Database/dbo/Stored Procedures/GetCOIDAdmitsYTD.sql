


-- =============================================
-- Author:		Mike Floyd
-- Create date: 06/21/2011
-- Description:	Get COID admits by YTD
-- =============================================
CREATE PROCEDURE [dbo].[GetCOIDAdmitsYTD] 
    (
        @year int,
        @month int
    )
AS
BEGIN
    declare @pdts_provider_id int;
    declare @note varchar(1000);
    
	select p.coid, c.name, sum(b.admits) as admits
	from provider p
		join currentyear_admit b
			on p.pdts_provider_id = b.pdts_provider_id
				and b.year = @year
				and b.monthno <= @month
                
		join facility c 
			on p.coid = c.coid
	group by p.coid, c.name
	order by c.name
END

