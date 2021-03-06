﻿CREATE TABLE [dbo].[ig_Worksheets] (
    [WORKSHEET_ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [COID]                              VARCHAR (5)     NULL,
    [PROVIDER_ID]                       INT             NOT NULL,
    [IGTYPE_ID]                         INT             NULL,
    [IGSTATUS_ID]                       INT             NULL,
    [IG_PRACTICETYPE_ID]                INT             NULL,
    [IG_BILLINGSYSTEM_ID]               INT             NULL,
    [IG_MGMACOMPTYPE_ID]                INT             NULL,
    [GROUP_EMP_AGREEMENT_FLAG]          VARCHAR (1)     NULL,
    [PHYSICIAN_SALARY]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_PHYSICIAN_SALARY] DEFAULT ((0)) NOT NULL,
    [START_DATE]                        DATETIME        NOT NULL,
    [MONTHLY_AMT]                       DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_MONTHLY_AMT] DEFAULT ((0)) NOT NULL,
    [MONTHS]                            INT             CONSTRAINT [DF_ig_Worksheets_MONTHS] DEFAULT ((0)) NOT NULL,
    [TOTAL_AMT]                         DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_TOTAL_AMT] DEFAULT ((0)) NOT NULL,
    [FASB_LOSS_AMT]                     DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_FASB_LOSS_AMT] DEFAULT ((0)) NOT NULL,
    [FASB_START_EXP]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_FASB_START_EXP] DEFAULT ((0)) NOT NULL,
    [ADV_PAYMENT_AMT]                   DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADV_PAYMENT_AMT] DEFAULT ((0)) NOT NULL,
    [ADV_RECOVERY_MONTHS]               INT             CONSTRAINT [DF_ig_Worksheets_ADV_RECOVERY_MONTHS] DEFAULT ((0)) NOT NULL,
    [IG_COMPLETION_DATE]                DATETIME        NULL,
    [AMT_MARKETING_EXP]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_MARKETING_EXP] DEFAULT ((0)) NOT NULL,
    [AMT_RELOCATION_EXP]                DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_RELOCATION_EXP] DEFAULT ((0)) NOT NULL,
    [AMT_EDUCATION_STIPEND]             DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_EDUCATION_STIPEND] DEFAULT ((0)) NOT NULL,
    [AMT_STUDENT_LOANS]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_STUDENT_LOANS] DEFAULT ((0)) NOT NULL,
    [AMT_CONSULTING_COSTS]              DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_CONSULTING_COSTS] DEFAULT ((0)) NOT NULL,
    [AMT_SIGNON_BONUS]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_SIGNON_BONUS] DEFAULT ((0)) NOT NULL,
    [AMT_STARTUP_MISC]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_AMT_STARTUP_MISC] DEFAULT ((0)) NOT NULL,
    [PM_CONSULTANT_FNAME]               VARCHAR (50)    NULL,
    [PM_CONSULTANT_LNAME]               VARCHAR (50)    NULL,
    [PM_CONSULTANT_EMAIL]               VARCHAR (100)   NULL,
    [PM_CONSULTANT_PHONE]               VARCHAR (25)    NULL,
    [PM_CONSULTANT_NOTES]               VARCHAR (MAX)   NULL,
    [CRED_CONSULTANT_FNAME]             VARCHAR (50)    NULL,
    [CRED_CONSULTANT_LNAME]             VARCHAR (50)    NULL,
    [CRED_CONSULTANT_EMAIL]             VARCHAR (100)   NULL,
    [CRED_CONSULTANT_PHONE]             VARCHAR (25)    NULL,
    [CRED_CONSULTANT_NOTES]             VARCHAR (MAX)   NULL,
    [PROVIDER_SENTDATE_MEDICARE]        DATETIME        NULL,
    [PROVIDER_SENTDATE_MEDICAID]        DATETIME        NULL,
    [PROVIDER_SENTDATE_BCBS]            DATETIME        NULL,
    [PROVIDER_APPROVED_MEDICARE]        DATETIME        NULL,
    [PROVIDER_APPROVED_MEDICAID]        DATETIME        NULL,
    [PROVIDER_APPROVED_BCBS]            DATETIME        NULL,
    [PROVIDER_EFFECTIVE_MEDICARE]       DATETIME        NULL,
    [PROVIDER_EFFECTIVE_MEDICAID]       DATETIME        NULL,
    [PROVIDER_EFFECTIVE_BCBS]           DATETIME        NULL,
    [CREATED_DATE]                      DATETIME        NULL,
    [CREATED_BY]                        INT             NULL,
    [ADVPD_HOSTFASB_BALANCE]            DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_HOSTFASB_BALANCE] DEFAULT ((0)) NOT NULL,
    [ADVPD_CHECK_DATE]                  DATETIME        NULL,
    [ADVPD_CHECK_NUMBER]                INT             NULL,
    [ADVPD_CEO_CFO_INITIALS]            VARCHAR (50)    NULL,
    [ADVPD_AR_0_30]                     DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_0_30] DEFAULT ((0)) NOT NULL,
    [ADVPD_AR_31_60]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_31_60] DEFAULT ((0)) NOT NULL,
    [ADVPD_AR_61_90]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_61_90] DEFAULT ((0)) NOT NULL,
    [ADVPD_AR_91_120]                   DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_91_120] DEFAULT ((0)) NOT NULL,
    [ADVPD_AR_121_150]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_121_150] DEFAULT ((0)) NOT NULL,
    [ADVPD_AR_150_PLUS]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_150_PLUS] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_MARKETING_EXP]           DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_MARKETING_EXP] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_RELOCATION_EXP]          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_RELOCATION_EXP] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_EDUCATION_STIPEND]       DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_EDUCATION_STIPEND] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_STUDENT_LOANS]           DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_STUDENT_LOANS] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_CONSULTING_COSTS]        DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_CONSULTING_COSTS] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_SIGNON_BONUS]            DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_SIGNON_BONUS] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMT_STARTUP_MISC]            DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMT_STARTUP_MISC] DEFAULT ((0)) NOT NULL,
    [RECRUITING_MONTHS]                 INT             NULL,
    [LASTDAY_OF_FIRSTMONTH]             INT             NULL,
    [FIRSTDAY_STARTFLAG]                VARCHAR (1)     NULL,
    [EXCESS_PAYMENT_ROLL_FLAG]          VARCHAR (1)     NULL,
    [UPDATED_DATE]                      DATETIME        NULL,
    [UPDATED_BY]                        INT             NULL,
    [ADVPD_AR_TOTAL]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AR_TOTAL] DEFAULT ((0)) NOT NULL,
    [ADVPD_EXPENSE_TOTAL]               DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_EXPENSE_TOTAL] DEFAULT ((0)) NOT NULL,
    [IG_Modification_Locked]            VARCHAR (1)     NULL,
    [AR_RiskStatus_Current]             INT             NULL,
    [Volume_RiskStatus_Current]         INT             NULL,
    [Collection_RiskStatus_Current]     INT             NULL,
    [AR_RiskStatus_Proposed]            INT             NULL,
    [Volume_RiskStatus_Proposed]        INT             NULL,
    [Collection_RiskStatus_Proposed]    INT             NULL,
    [AR_RiskStatus_Override]            INT             NULL,
    [Volume_RiskStatus_Override]        INT             NULL,
    [Collection_RiskStatus_Override]    INT             NULL,
    [PROVIDER_SENTDATE_MEDICARE_GROUP]  DATETIME        NULL,
    [PROVIDER_APPROVED_MEDICARE_GROUP]  DATETIME        NULL,
    [PROVIDER_EFFECTIVE_MEDICARE_GROUP] DATETIME        NULL,
    [PROVIDER_SENTDATE_MEDICAID_GROUP]  DATETIME        NULL,
    [PROVIDER_APPROVED_MEDICAID_GROUP]  DATETIME        NULL,
    [PROVIDER_EFFECTIVE_MEDICAID_GROUP] DATETIME        NULL,
    [PROVIDER_SENTDATE_CAQH]            DATETIME        NULL,
    [PROVIDER_APPROVED_CAQH]            DATETIME        NULL,
    [PROVIDER_EFFECTIVE_CAQH]           DATETIME        NULL,
    [ADVPD_STARTDATE]                   DATETIME        NULL,
    [ADV_AMORTIZATION_AMT]              DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADV_AMORTIZATION_AMT] DEFAULT ((0)) NOT NULL,
    [TOTAL_FASB_AMT]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_TOTAL_FASB_AMT] DEFAULT ((0)) NOT NULL,
    [FIRST_MONTH_AMT]                   DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_FIRST_MONTH_AMT] DEFAULT ((0)) NOT NULL,
    [LAST_MONTH_AMT]                    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_LAST_MONTH_AMT] DEFAULT ((0)) NOT NULL,
    [ADVPD_FASB_VARIANCE]               DECIMAL (11, 4) CONSTRAINT [DF_ig_Worksheets_ADVPD_FASB_VARIANCE] DEFAULT ((0)) NOT NULL,
    [ADVPD_AMORTIZATION_AMT]            DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_AMORTIZATION_AMT] DEFAULT ((0)) NOT NULL,
    [ADVPD_NET_CHK_AMT_DUE_TO_PHYS]     DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_NET_CHK_AMT_DUE_TO_PHYS] DEFAULT ((0)) NOT NULL,
    [ADVPD_NET_CHK_AMT_PAID_TO_PHYS]    DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_NET_CHK_AMT_PAID_TO_PHYS] DEFAULT ((0)) NOT NULL,
    [ADVPD_REMAINING_FASB_BAL]          DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_ADVPD_REMAINING_FASB_BAL] DEFAULT ((0)) NOT NULL,
    [LTD_Payments]                      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_LTD_Payments] DEFAULT ((0)) NOT NULL,
    [AR_RiskStatus_Prior]               INT             NULL,
    [Volume_RiskStatus_Prior]           INT             NULL,
    [Collection_RiskStatus_Prior]       INT             NULL,
    [AlertStatus_Current]               INT             NULL,
    [AlertStatus_Prior]                 INT             NULL,
    [last_monthlyfinancial_date]        INT             NULL,
    [MonthEndStatus]                    VARCHAR (15)    NULL,
    [PM_CONSULTANT_PHONE2]              VARCHAR (25)    NULL,
    [PM_COMPANY]                        VARCHAR (100)   NULL,
    [CredCompletedDate]                 DATETIME        NULL,
    [CredCompletedFlag]                 VARCHAR (1)     NULL,
    [EXTENSION_1]                       SMALLINT        CONSTRAINT [DF_ig_Worksheets_EXTENSION_1] DEFAULT ((0)) NOT NULL,
    [EXTENSION_2]                       SMALLINT        CONSTRAINT [DF_ig_Worksheets_EXTENSION_2] DEFAULT ((0)) NOT NULL,
    [IG_BONUS]                          DECIMAL (11, 2) NULL,
    [INS_POLICY_PREMIUM_ALLOWANCE]      DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_INS_POLICY_PREMIUM_ALLOWANCE] DEFAULT ((0)) NOT NULL,
    [IMPUTED_INTEREST_RATE]             DECIMAL (5, 2)  CONSTRAINT [DF_ig_Worksheets_IMPUTED_INTEREST_RATE] DEFAULT ((0)) NOT NULL,
    [IMMIGRATION_FEES]                  DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheets_IMMIGRATION_FEES] DEFAULT ((0)) NOT NULL,
    [FORGIVENESS_PERIOD]                INT             NULL,
    [FORGIVENESS_INTEREST_RATE]         DECIMAL (5, 2)  NULL,
    CONSTRAINT [PK_igWorksheets] PRIMARY KEY CLUSTERED ([WORKSHEET_ID] ASC),
    CONSTRAINT [FK_IGWORKSHEET_AlertStatusCurrent] FOREIGN KEY ([AlertStatus_Current]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_AlertStatusPrior] FOREIGN KEY ([AlertStatus_Prior]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_ARRiskCurrent] FOREIGN KEY ([AR_RiskStatus_Current]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_ARRiskOverride] FOREIGN KEY ([AR_RiskStatus_Override]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_ARRiskPrior] FOREIGN KEY ([AR_RiskStatus_Prior]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_ARRiskProposed] FOREIGN KEY ([AR_RiskStatus_Proposed]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_CollectionRiskCurrent] FOREIGN KEY ([Collection_RiskStatus_Current]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_CollectionRiskOverride] FOREIGN KEY ([Collection_RiskStatus_Override]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_CollectionRiskPrior] FOREIGN KEY ([Collection_RiskStatus_Prior]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_CollectionRiskProposed] FOREIGN KEY ([Collection_RiskStatus_Proposed]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_CREATEUSER] FOREIGN KEY ([CREATED_BY]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_IGWORKSHEET_IGBILLINGSYSTEM] FOREIGN KEY ([IG_BILLINGSYSTEM_ID]) REFERENCES [dbo].[ig_BillingSystems] ([BILLINGSYSTEM_ID]),
    CONSTRAINT [FK_IGWORKSHEET_IGMGMACompType] FOREIGN KEY ([IG_MGMACOMPTYPE_ID]) REFERENCES [dbo].[ig_MGMACompType] ([MGMACOMPTYPE_ID]),
    CONSTRAINT [FK_IGWORKSHEET_IGPRACTICETYPE] FOREIGN KEY ([IG_PRACTICETYPE_ID]) REFERENCES [dbo].[ig_PracticeType] ([PRACTICETYPE_ID]),
    CONSTRAINT [FK_IGWORKSHEET_IGSTATUS] FOREIGN KEY ([IGSTATUS_ID]) REFERENCES [dbo].[ig_Status] ([IGSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_IGTYPE] FOREIGN KEY ([IGTYPE_ID]) REFERENCES [dbo].[ig_Type] ([IGTYPE_ID]),
    CONSTRAINT [FK_IGWORKSHEET_PROVIDERS] FOREIGN KEY ([PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_IGWORKSHEET_UPDATEUSER] FOREIGN KEY ([UPDATED_BY]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_IGWORKSHEET_VolumeRiskCurrent] FOREIGN KEY ([Volume_RiskStatus_Current]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_VolumeRiskOverride] FOREIGN KEY ([Volume_RiskStatus_Override]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_VolumeRiskPrior] FOREIGN KEY ([Volume_RiskStatus_Prior]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID]),
    CONSTRAINT [FK_IGWORKSHEET_VolumeRiskProposed] FOREIGN KEY ([Volume_RiskStatus_Proposed]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID])
);

