create function [dbo].[ufn_AgeCalc](@DOB datetime,@Date datetime) 

returns smallint 

as
 
----------------------------------------------------
 
-- * Created By David Wiseman, Updated 03/11/2006
 
-- * http://www.wisesoft.co.uk
 
-- * This function calculates a persons age at a 

-- * specified date from their date of birth.
 
-- * Usage:
 
-- * select dbo.fAgeCalc('1982-04-18',GetDate())
 
-- * select dbo.fAgeCalc('1982-04-18','2006-11-03')
 
----------------------------------------------------
 
begin
 
return (
 
      select case when month(@DOB)>month(@Date) then datediff(yyyy,@DOB,@Date)-1 

                  when month(@DOB)<month(@Date) then datediff(yyyy,@DOB,@Date) 

                  when month(@DOB)=month(@Date) then 

                        case when day(@DOB)>day(@Date)
 
                              then datediff(yyyy,@DOB,@Date)-1 

                        else datediff(yyyy,@DOB,@Date) end 

                  end) 

end
