CREATE procedure [dbo].[sp_report_IGAlert]
	(
		@division int,
		@type int,
		@status int,
		@currstatus int
	)
as
begin
	select 
		w.WORKSHEET_ID,
		w.last_monthlyfinancial_date,
		div.NAME,
		IGSTATUS_DESC,
		f.NAME as FAC_NAME,
		w.IGSTATUS_ID,
		cast((DatePart(yyyy,getdate())*100)+DatePart(mm,getdate()) as int) as currentmonthyear,
		CASE
			WHEN currentRiskSts.IGRISKSTATUS_DESC is not null and priorRiskSts.IGRISKSTATUS_DESC is not null
				THEN isNull(currentRiskSts.IGRISKSTATUS_DESC,'') + '/' + isNull(priorRiskSts.IGRISKSTATUS_DESC,'')
			WHEN currentRiskSts.IGRISKSTATUS_DESC is null and priorRiskSts.IGRISKSTATUS_DESC is not null
				THEN isNull(priorRiskSts.IGRISKSTATUS_DESC,'')
			WHEN currentRiskSts.IGRISKSTATUS_DESC is not null and priorRiskSts.IGRISKSTATUS_DESC is not null
				THEN isNull(currentRiskSts.IGRISKSTATUS_DESC,'')
			ELSE ''
		END as alertstatus,
		isNull(p.LAST_NAME,'') + ', ' + isNull(p.FIRST_NAME,'') + ' ' + isNull(p.MIDDLE_NAME,'') as PROVIDER_NAME, 	
		IGTYPE_DESC,
		CASE
			WHEN Cast(Cast(DateDiff(d,w.START_DATE,getdate()) as float)/30 as Decimal(6,1)) < w.MONTHS
				THEN Cast(Cast(DateDiff(d,w.START_DATE,getdate()) as float)/30 as Decimal(6,1))
			ELSE w.MONTHS
		END	as CURRENT_IG_MONTH,
		w.MONTHS,
		CASE
			WHEN (CUMM_AMT_EXCEEDING_FASB IS NULL or CUMM_AMT_EXCEEDING_FASB = 0) THEN 'N'
			ELSE 'Y'
		END as EXCEEDS_FASB,
		isNull(arRisk.IGRISKSTATUS_DESC,'') as AR_RISK_STATUS,
		isNull(volRisk.IGRISKSTATUS_DESC,'') as VOLUME_RISK_STATUS,
		isNull(collRisk.IGRISKSTATUS_DESC,'') as COLLECTION_RISK_STATUS,
		GROUP_EMP_AGREEMENT_FLAG,
		PRACTICETYPE_DESC,
		currMth.AR_VARIANCE,isNull(sp.SHORT_NAME,'') as SPECIALTY_SHORT_NAME,
		w.START_DATE,w.PHYSICIAN_SALARY,w.MONTHLY_AMT,TOTAL_AMT as TOTAL_CONTRACT,TOTAL_FASB_AMT,
		currMth.REMAINING_FASB_BAL as FASB_LIAB_BAL,currMth.CUMM_AMT_EXCEEDING_FASB,w.LTD_PAYMENTS,
		CASE
			WHEN w.MONTHLY_AMT > 0
				THEN cast(currMth.CASH_RECEIPTS as float)/w.MONTHLY_AMT
			ELSE 0
		END as CURRENT_MTH_COLL_TO_IG,
		currMth.COLLECTION_PERCENTAGE as TARGET_COLL_TO_IG,
		currMth.AVG_3MTH_CHARGES,
		currMth.AVG_3MTH_NETREVENUE_TO_IG,
		currMth.GROSS_CHARGES,
		currMth.CASH_RECEIPTS,
		currMth.DSO,
		(
			select ws_note_text 
			from ig_Worksheet_Notes
			where ws_note_id = (
									select top 1 c.ws_note_id 
									from ig_Worksheet_CashRcpts a with (nolock)
										join ig_Worksheet_CashRcpts_Note_Xref b with (nolock)
											on a.receipt_id = b.receipt_id
											
										join ig_Worksheet_Notes c with (nolock)
											on b.ws_note_id = c.ws_note_id
												and c.ws_note_type_id = 5
									where a.worksheet_id = w.worksheet_id
									order by receipt_year desc, receipt_month desc
								)
		) as volume_risk_note,
		(
			select ws_note_text 
			from ig_Worksheet_Notes
			where ws_note_id = (
									select top 1 c.ws_note_id 
									from ig_Worksheet_CashRcpts a with (nolock)
										join ig_Worksheet_CashRcpts_Note_Xref b with (nolock)
											on a.receipt_id = b.receipt_id
											
										join ig_Worksheet_Notes c with (nolock)
											on b.ws_note_id = c.ws_note_id
												and c.ws_note_type_id = 7
									where a.worksheet_id = w.worksheet_id
									order by receipt_year desc, receipt_month desc
								)
		) as ar_risk_note,
		(
			select ws_note_text 
			from ig_Worksheet_Notes
			where ws_note_id = (
									select top 1 c.ws_note_id 
									from ig_Worksheet_CashRcpts a with (nolock)
										join ig_Worksheet_CashRcpts_Note_Xref b with (nolock)
											on a.receipt_id = b.receipt_id
											
										join ig_Worksheet_Notes c with (nolock)
											on b.ws_note_id = c.ws_note_id
												and c.ws_note_type_id = 6
									where a.worksheet_id = w.worksheet_id
									order by receipt_year desc, receipt_month desc
								)
		) as collection_risk_note,
		isnull(w.CredCompletedFlag, 'N') as CredCompletedFlag
	from ig_Worksheets w with (nolock)
		left join ig_Status s with (nolock) 
			on s.IGSTATUS_ID = w.IGSTATUS_ID
			
		left join ig_Type t with (nolock) 
			on t.IGTYPE_ID = w.IGTYPE_ID
			
		left join ig_PracticeType pt with (nolock) 
			on pt.PRACTICETYPE_ID = w.IG_PRACTICETYPE_ID
			
		left join ig_BillingSystems bs with (nolock) 
			on bs.BILLINGSYSTEM_ID = w.IG_BILLINGSYSTEM_ID
			
		left join provider p with (nolock)
			on p.PDTS_PROVIDER_ID = w.PROVIDER_ID
			
		left join Specialty sp with (nolock) 
			on sp.SPECIALTY_ID = p.SPECIALTY_ID
	
		left join ig_RiskStatus priorRiskSts with (nolock)
			on priorRiskSts.IGRISKSTATUS_ID = w.AlertStatus_Prior
			
		left join ig_RiskStatus currentRiskSts with (nolock)
			on currentRiskSts.IGRISKSTATUS_ID = w.AlertStatus_Current
			
		left join ig_RiskStatus arRisk with (nolock) 
			on arRisk.IGRISKSTATUS_ID = w.AR_RiskStatus_Current
			
		left join ig_RiskStatus volRisk with (nolock)
			on volRisk.IGRISKSTATUS_ID = w.Volume_RiskStatus_Current
			
		left join ig_RiskStatus collRisk with (nolock)
			on collRisk.IGRISKSTATUS_ID = w.Collection_RiskStatus_Current
			
		left join ig_Worksheet_CashRcpts currMth with (nolock)
			on currMth.WORKSHEET_ID = w.WORKSHEET_ID 
				and currMth.RECEIPT_ID = 
				(
					Select max(RECEIPT_ID) 
					from ig_Worksheet_CashRcpts with (nolock)
					where WORKSHEET_ID = w.WORKSHEET_ID
				)
				
		left join Facility f with (nolock) 
			on f.COID = w.COID
			
		left join Division div with (nolock)
			on div.DIVISION_ID = f.DIVISION_ID
	where (div.DIVISION_ID = @division or @division = 1)
		and (w.IGTYPE_ID = @type or @type = 0 or @type is null)
		and (w.IGSTATUS_ID = @status or @status = 0 or @status is null)
		and
			(
				(@currstatus = 0)
			or
				(@currstatus = 1 
					and (w.IGSTATUS_ID <> 3 
					and last_monthlyfinancial_date <> cast((DatePart(yyyy,getdate())*100)+DatePart(mm,getdate()) as int))
				)
			or
				(@currstatus = 2 
					and (w.IGSTATUS_ID = 3 
					or (w.IGSTATUS_ID <> 3 
						and last_monthlyfinancial_date = cast((DatePart(yyyy,getdate())*100)+DatePart(mm,getdate()) as int)))
				)
			)
	ORDER BY div.NAME,IGSTATUS_DESC,FAC_NAME,PROVIDER_NAME,w.WORKSHEET_ID
end

