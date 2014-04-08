CREATE TABLE [dbo].[BudgetSurgeryPercentage] (
    [BUDGET_SURGERY_PERCENTAGE_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]                    INT            NOT NULL,
    [BUDGET_YEAR]                         INT            NOT NULL,
    [SURGICAL_TYPE_ID]                    INT            NOT NULL,
    [MONTHNO]                             INT            NOT NULL,
    [AVERAGE_INPATIENT_PERCENT_OF_TOTAL]  DECIMAL (4, 2) NOT NULL,
    [AVERAGE_OUTPATIENT_PERCENT_OF_TOTAL] DECIMAL (4, 2) NOT NULL,
    CONSTRAINT [PK_BudgetSurgeryPercentage] PRIMARY KEY CLUSTERED ([BUDGET_SURGERY_PERCENTAGE_ID] ASC),
    CONSTRAINT [FK_BudgetSurgery_Percentages_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_BudgetSurgery_Percentages_Surgical_Type] FOREIGN KEY ([SURGICAL_TYPE_ID]) REFERENCES [dbo].[Surgical_Type] ([SURGICAL_TYPE_ID])
);

