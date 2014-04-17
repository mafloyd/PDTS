CREATE TABLE [dbo].[ig_Report_RiskSummary] (
    [SUMMARY_ID]              INT             IDENTITY (1, 1) NOT NULL,
    [REPORT_DATE]             DATETIME        NULL,
    [REPORT_MONTH]            INT             NULL,
    [REPORT_YEAR]             INT             NULL,
    [DIVISION_ID]             INT             NULL,
    [RISK_LEVEL]              VARCHAR (100)   NULL,
    [TOTAL_GROUP_COUNT]       INT             NULL,
    [TOTAL_SOLO_COUNT]        INT             NULL,
    [TOTAL_COUNT]             INT             NULL,
    [CURRENTMTH_TOTAL_COUNT]  INT             NULL,
    [CURRENTMTH_TOTAL_PCT]    DECIMAL (11, 4) NULL,
    [PRIORMTH_RISK_COUNT]     INT             NULL,
    [PRIORMTH_TOTAL_COUNT]    INT             NULL,
    [PRIORMTH_TOTAL_PCT]      DECIMAL (11, 4) NULL,
    [MONTH_OVER_MONTH_CHANGE] DECIMAL (11, 4) NULL,
    [RISKSTATUS_ID]           INT             NULL,
    CONSTRAINT [PK_igReportRiskSummary] PRIMARY KEY CLUSTERED ([SUMMARY_ID] ASC)
);

