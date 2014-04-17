CREATE TABLE [dbo].[BudgetAdmitPercentage] (
    [BUDGET_ADMIT_PERCENTAGE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]           INT            NOT NULL,
    [BUDGET_YEAR]                INT            NOT NULL,
    [MONTHNO]                    INT            NOT NULL,
    [AVERAGE_PERCENTAGE]         DECIMAL (6, 2) NOT NULL,
    CONSTRAINT [PK_BudgetAdmitPercentage] PRIMARY KEY CLUSTERED ([BUDGET_ADMIT_PERCENTAGE_ID] ASC),
    CONSTRAINT [FK_BudgetAdmitPercentage_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

