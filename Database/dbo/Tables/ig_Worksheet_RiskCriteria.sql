CREATE TABLE [dbo].[ig_Worksheet_RiskCriteria] (
    [RC_ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]                 INT             NULL,
    [MONTH]                        INT             NULL,
    [CASH_PERCENT]                 DECIMAL (11, 2) NULL,
    [NET_PERCENT]                  DECIMAL (11, 2) NULL,
    [CASH_AMOUNT]                  DECIMAL (11, 2) NULL,
    [NET_AMOUNT]                   DECIMAL (11, 2) NULL,
    [CREATE_DATE]                  DATETIME        CONSTRAINT [DF_ig_Worksheet_RiskCriteria_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [UPDATE_DATE]                  DATETIME        NULL,
    [PERCENTAGE_OF_MONTHLY_AMOUNT] DECIMAL (5, 2)  NULL,
    CONSTRAINT [PK_igWorksheetRiskCriteria] PRIMARY KEY CLUSTERED ([RC_ID] ASC),
    CONSTRAINT [FK_IGRISKCRIT_IGWORKSHEET] FOREIGN KEY ([WORKSHEET_ID]) REFERENCES [dbo].[ig_Worksheets] ([WORKSHEET_ID]) ON DELETE CASCADE
);

