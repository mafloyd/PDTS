﻿CREATE TABLE [dbo].[ig_Worksheet_CashRcpts] (
    [RECEIPT_ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]                     INT             NULL,
    [MONTH]                            INT             NOT NULL,
    [CASH_RECEIPTS]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CASH_RECEIPTS] DEFAULT ((0)) NOT NULL,
    [ADJUSTMENTS]                      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_ADJUSTMENTS] DEFAULT ((0)) NOT NULL,
    [GROSS_CHARGES]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_GROSS_CHARGES] DEFAULT ((0)) NOT NULL,
    [TOTAL_VISITS]                     INT             CONSTRAINT [DF_ig_Worksheet_CashRcpts_TOTAL_VISITS] DEFAULT ((0)) NOT NULL,
    [AR_0_30]                          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_0_30] DEFAULT ((0)) NOT NULL,
    [AR_31_60]                         DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_31_60] DEFAULT ((0)) NOT NULL,
    [AR_61_90]                         DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_61_90] DEFAULT ((0)) NOT NULL,
    [AR_91_120]                        DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_91_120] DEFAULT ((0)) NOT NULL,
    [AR_121_150]                       DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_121_150] DEFAULT ((0)) NOT NULL,
    [AR_150_PLUS]                      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_150_PLUS] DEFAULT ((0)) NOT NULL,
    [MISC_CASH_RCPTS]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_MISC_CASH_RCPTS] DEFAULT ((0)) NOT NULL,
    [EXCESS_RECOVERED]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_EXCESS_RECOVERED] DEFAULT ((0)) NOT NULL,
    [HOSTFASB_BALANCE]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_HOSTFASB_BALANCE] DEFAULT ((0)) NOT NULL,
    [AMT_MARKETING_EXP]                DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_MARKETING_EXP] DEFAULT ((0)) NOT NULL,
    [AMT_RELOCATION_EXP]               DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_RELOCATION_EXP] DEFAULT ((0)) NOT NULL,
    [AMT_EDUCATION_STIPEND]            DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_EDUCATION_STIPEND] DEFAULT ((0)) NOT NULL,
    [AMT_STUDENT_LOANS]                DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_STUDENT_LOANS] DEFAULT ((0)) NOT NULL,
    [AMT_CONSULTING_COSTS]             DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_CONSULTING_COSTS] DEFAULT ((0)) NOT NULL,
    [AMT_SIGNON_BONUS]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_SIGNON_BONUS] DEFAULT ((0)) NOT NULL,
    [AMT_STARTUP_MISC]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMT_STARTUP_MISC] DEFAULT ((0)) NOT NULL,
    [HOSTFASB_ADJUSTMENT]              DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_HOSTFASB_ADJUSTMENT] DEFAULT ((0)) NOT NULL,
    [CHECK_DATE]                       DATETIME        NULL,
    [CHECK_NUMBER]                     INT             NULL,
    [CEO_CFO_INITIALS]                 VARCHAR (50)    NULL,
    [PHYS_CASH_RCPTS]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_PHYS_CASH_RCPTS] DEFAULT ((0)) NOT NULL,
    [AR_TOTAL]                         DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_TOTAL] DEFAULT ((0)) NOT NULL,
    [EXPENSE_TOTAL]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_EXPENSE_TOTAL] DEFAULT ((0)) NOT NULL,
    [DATE_SUBMITTED_PHYS]              DATETIME        NULL,
    [COLLECTION_PERCENTAGE]            DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_COLLECTION_PERCENTAGE] DEFAULT ((0)) NOT NULL,
    [ACTUAL_CASH_PERCENTAGE]           DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_ACTUAL_CASH_PERCENTAGE] DEFAULT ((0)) NOT NULL,
    [ACTUAL_NET_PERCENTAGE]            DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_ACTUAL_NET_PERCENTAGE] DEFAULT ((0)) NOT NULL,
    [CASH_PROJECTION_VARIANCE]         DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CASH_PROJECTION_VARIANCE] DEFAULT ((0)) NOT NULL,
    [NET_PROJECTION_VARIANCE]          DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_NET_PROJECTION_VARIANCE] DEFAULT ((0)) NOT NULL,
    [AR_VARIANCE]                      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_VARIANCE] DEFAULT ((0)) NOT NULL,
    [DSO]                              DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_DSO] DEFAULT ((0)) NOT NULL,
    [VOLUME_RISK_STATUS]               INT             NULL,
    [COLLECTION_RISK_STATUS]           INT             NULL,
    [AR_RISK_STATUS]                   INT             NULL,
    [RECEIPT_MONTH]                    INT             NULL,
    [RECEIPT_YEAR]                     INT             NULL,
    [CREATED_DATE]                     DATETIME        NULL,
    [CREATED_BY]                       INT             NULL,
    [UPDATED_DATE]                     DATETIME        NULL,
    [UPDATED_BY]                       INT             NULL,
    [AR_90DAYS_PERCENT]                DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AR_90DAYS_PERCENT] DEFAULT ((0)) NOT NULL,
    [AVG_3MTH_CHARGES]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AVG_3MTH_CHARGES] DEFAULT ((0)) NOT NULL,
    [AVG_3MTH_NETREVENUE]              DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AVG_3MTH_NETREVENUE] DEFAULT ((0)) NOT NULL,
    [AVG_3MTH_NETREVENUE_TO_IG]        DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AVG_3MTH_NETREVENUE_TO_IG] DEFAULT ((0)) NOT NULL,
    [CUR_MTH_EXCESS_COLLECTIONS]       DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CUR_MTH_EXCESS_COLLECTIONS] DEFAULT ((0)) NOT NULL,
    [PRV_MTH_EXCESS_COLLECTIONS]       DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_PRV_MTH_EXCESS_COLLECTIONS] DEFAULT ((0)) NOT NULL,
    [CUMM_EXCESS_COLLECTIONS_MTHBEGIN] DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CUMM_EXCESS_COLLECTIONS_MTHBEGIN] DEFAULT ((0)) NOT NULL,
    [CUMM_EXCESS_COLLECTIONS]          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CUMM_EXCESS_COLLECTIONS] DEFAULT ((0)) NOT NULL,
    [EXCESS_RECOVERED_THIS_MTH_DUE]    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_EXCESS_RECOVERED_THIS_MTH_DUE] DEFAULT ((0)) NOT NULL,
    [CUMM_EXCESS_COLLECTIONS_MTHEND]   DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CUMM_EXCESS_COLLECTIONS_MTHEND] DEFAULT ((0)) NOT NULL,
    [NET_CHK_AMT_DUE_TO_PHYS]          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_NET_CHK_AMT_DUE_TO_PHYS] DEFAULT ((0)) NOT NULL,
    [NET_CHK_AMT_PAID_TO_PHYS]         DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_NET_CHK_AMT_PAID_TO_PHYS] DEFAULT ((0)) NOT NULL,
    [CUMM_AMT_EXCEEDING_FASB]          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_CUMM_AMT_EXCEEDING_FASB] DEFAULT ((0)) NOT NULL,
    [REMAINING_FASB_BAL]               DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_REMAINING_FASB_BAL] DEFAULT ((0)) NOT NULL,
    [FASB_VARIANCE]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_FASB_VARIANCE] DEFAULT ((0)) NOT NULL,
    [AMORTIZATION_AMT]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_AMORTIZATION_AMT] DEFAULT ((0)) NOT NULL,
    [MTH_IGNET_ADVANCES]               DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_MTH_IGNET_ADVANCES] DEFAULT ((0)) NOT NULL,
    [RCPTS_LESS_ADV_RECOVERIES]        DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_RCPTS_LESS_ADV_RECOVERIES] DEFAULT ((0)) NOT NULL,
    [NET_REVENUE]                      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpts_NET_REVENUE] DEFAULT ((0)) NOT NULL,
    [NET_REVENUE_VARIANCE]             DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheet_CashRcpts_NET_REVENUE_VARIANCE] DEFAULT ((0)) NOT NULL,
    [CLOSED]                           BIT             CONSTRAINT [DF_ig_Worksheet_CashRcpts_CLOSED] DEFAULT ((0)) NOT NULL,
    [PERCENTAGE_OF_MONTHLY_AMOUNT]     DECIMAL (5, 2)  NULL,
    CONSTRAINT [PK_igWorksheetCashRcpts] PRIMARY KEY CLUSTERED ([RECEIPT_ID] ASC),
    CONSTRAINT [FK_IGCASHRCPT_IGWORKSHEET] FOREIGN KEY ([WORKSHEET_ID]) REFERENCES [dbo].[ig_Worksheets] ([WORKSHEET_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_IGWORKSHEETCASHRCPT_CREATEUSER] FOREIGN KEY ([CREATED_BY]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_IGWORKSHEETCASHRCPT_UPDATEUSER] FOREIGN KEY ([UPDATED_BY]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_IGWORKSHEETCASHRCPTS_ARRisk] FOREIGN KEY ([AR_RISK_STATUS]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEETCASHRCPTS_CollectionRisk] FOREIGN KEY ([COLLECTION_RISK_STATUS]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEETCASHRCPTS_VolumeRisk] FOREIGN KEY ([VOLUME_RISK_STATUS]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID])
);
