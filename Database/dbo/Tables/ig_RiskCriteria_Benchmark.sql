CREATE TABLE [dbo].[ig_RiskCriteria_Benchmark] (
    [RCBM_ID]         INT             IDENTITY (1, 1) NOT NULL,
    [CONTRACT_LENGTH] INT             NULL,
    [MONTH]           INT             NULL,
    [CASH_PERCENT]    DECIMAL (11, 2) NULL,
    [NET_PERCENT]     DECIMAL (11, 2) NULL,
    CONSTRAINT [PK_igRiskCriteriaBenchmark] PRIMARY KEY CLUSTERED ([RCBM_ID] ASC)
);

