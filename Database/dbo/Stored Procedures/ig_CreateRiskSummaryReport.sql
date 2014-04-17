create  procedure [dbo].[ig_CreateRiskSummaryReport]

as

-- Insert Current Month values for VOLUME RISK
insert into [ig_Report_RiskSummary] (REPORT_DATE,REPORT_YEAR,REPORT_MONTH,DIVISION_ID,RISKSTATUS_ID,RISK_LEVEL,TOTAL_GROUP_COUNT,TOTAL_SOLO_COUNT,TOTAL_COUNT,CURRENTMTH_TOTAL_COUNT,CURRENTMTH_TOTAL_PCT)
select getdate() as REPORT_DATE,RECEIPT_YEAR,RECEIPT_MONTH,DIVISION_ID,cr.VOLUME_RISK_STATUS,'Volume Risk' as RiskType,
	sum(case
		when IG_PRACTICETYPE_ID = 1 and VOLUME_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalGROUP,
	sum(case
		when IG_PRACTICETYPE_ID = 2 and VOLUME_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalSOLO,
	sum(case
		when VOLUME_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalRiskCount,
	count(*) as totalIGs,
	cast(sum(case
		when VOLUME_RISK_STATUS in (2,3) then 1
		else 0
	end) as float)/count(*) 
	as CURRENTMONTH_PERCENT
from ig_Worksheet_CashRcpts cr
	join ig_worksheets w on w.worksheet_id = cr.worksheet_id
	join Facility f on f.COID = w.COID
where MONTH > 3
and ((RECEIPT_YEAR=2011 and RECEIPT_MONTH<=6) or RECEIPT_YEAR<2011)
group by RECEIPT_MONTH,RECEIPT_YEAR,DIVISION_ID,cr.VOLUME_RISK_STATUS

-- Insert Current Month values for AR RISK
insert into [ig_Report_RiskSummary] (REPORT_DATE,REPORT_YEAR,REPORT_MONTH,DIVISION_ID,RISKSTATUS_ID,RISK_LEVEL,TOTAL_GROUP_COUNT,TOTAL_SOLO_COUNT,TOTAL_COUNT,CURRENTMTH_TOTAL_COUNT,CURRENTMTH_TOTAL_PCT)
select getdate() as REPORT_DATE,RECEIPT_YEAR,RECEIPT_MONTH,DIVISION_ID,cr.AR_RISK_STATUS,'AR Risk' as RiskType,
	sum(case
		when IG_PRACTICETYPE_ID = 1 and AR_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalGROUP,
	sum(case
		when IG_PRACTICETYPE_ID = 2 and AR_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalSOLO,
	sum(case
		when AR_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalRiskCount,
	count(*) as totalIGs,
	cast(sum(case
		when AR_RISK_STATUS in (2,3) then 1
		else 0
	end) as float)/count(*) 
	as CURRENTMONTH_PERCENT
from ig_Worksheet_CashRcpts cr
	join ig_worksheets w on w.worksheet_id = cr.worksheet_id
	join Facility f on f.COID = w.COID
where MONTH > 3
and ((RECEIPT_YEAR=2011 and RECEIPT_MONTH<=6) or RECEIPT_YEAR<2011)
group by RECEIPT_MONTH,RECEIPT_YEAR,DIVISION_ID,cr.AR_Risk_Status

-- Insert Current Month values for COLLECTION RISK
insert into [ig_Report_RiskSummary] (REPORT_DATE,REPORT_YEAR,REPORT_MONTH,DIVISION_ID,RISKSTATUS_ID,RISK_LEVEL,TOTAL_GROUP_COUNT,TOTAL_SOLO_COUNT,TOTAL_COUNT,CURRENTMTH_TOTAL_COUNT,CURRENTMTH_TOTAL_PCT)
select getdate() as REPORT_DATE,RECEIPT_YEAR,RECEIPT_MONTH,DIVISION_ID,cr.COLLECTION_RISK_STATUS,'Collection Risk' as RiskType,
	sum(case
		when IG_PRACTICETYPE_ID = 1 and COLLECTION_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalGROUP,
	sum(case
		when IG_PRACTICETYPE_ID = 2 and COLLECTION_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalSOLO,
	sum(case
		when COLLECTION_RISK_STATUS in (2,3) then 1
		else 0
	end) as totalRiskCount,
	count(*) as totalIGs,
	cast(sum(case
		when COLLECTION_RISK_STATUS in (2,3) then 1
		else 0
	end) as float)/count(*) 
	as CURRENTMONTH_PERCENT
from ig_Worksheet_CashRcpts cr
	join ig_worksheets w on w.worksheet_id = cr.worksheet_id
	join Facility f on f.COID = w.COID
where MONTH > 3
and ((RECEIPT_YEAR=2011 and RECEIPT_MONTH<=6) or RECEIPT_YEAR<2011)
group by RECEIPT_MONTH,RECEIPT_YEAR,DIVISION_ID,cr.COLLECTION_RISK_STATUS


-- Zero out Prior Month values
update ig_Report_RiskSummary
set PRIORMTH_RISK_COUNT = isNull(PRIORMTH_RISK_COUNT,0),
	PRIORMTH_TOTAL_COUNT = isNull(PRIORMTH_TOTAL_COUNT,0),
	PRIORMTH_TOTAL_PCT = isNull(PRIORMTH_TOTAL_COUNT,0),
	MONTH_OVER_MONTH_CHANGE = isNull(MONTH_OVER_MONTH_CHANGE,0)
	
-- Update Prior Month values
update igCurrent
set PRIORMTH_RISK_COUNT = igPrior.TOTAL_COUNT,
	PRIORMTH_TOTAL_COUNT = igPrior.CURRENTMTH_TOTAL_COUNT,
	PRIORMTH_TOTAL_PCT = case when igPrior.CURRENTMTH_TOTAL_COUNT> 0 then igPrior.TOTAL_COUNT/cast(igPrior.CURRENTMTH_TOTAL_COUNT as float) else 0 end
from ig_Report_RiskSummary igCurrent
join ig_Report_RiskSummary igPrior 
	on 
		((igPrior.REPORT_MONTH = igCurrent.REPORT_MONTH-1
		and igPrior.REPORT_YEAR = igCurrent.REPORT_YEAR
		and igPrior.RISK_LEVEL = igCurrent.RISK_LEVEL
		and igPrior.RISKSTATUS_ID = igCurrent.RISKSTATUS_ID
		and igCurrent.REPORT_MONTH > 1)
		OR
		(igPrior.REPORT_MONTH = 12
		and igPrior.REPORT_YEAR = igCurrent.REPORT_YEAR-1
		and igPrior.RISK_LEVEL = igCurrent.RISK_LEVEL
		and igPrior.RISKSTATUS_ID = igCurrent.RISKSTATUS_ID
		and igCurrent.REPORT_MONTH = 1))

--Update Month over Month Change
update ig_Report_RiskSummary		
set MONTH_OVER_MONTH_CHANGE = CURRENTMTH_TOTAL_PCT - PRIORMTH_TOTAL_PCT

