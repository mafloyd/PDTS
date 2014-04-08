CREATE TABLE [dbo].[CapitalBudgetPurpose] (
    [CAPITAL_BUDGET_PURPOSE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                      VARCHAR (50) NOT NULL,
    [CREATE_DATE]               DATETIME     CONSTRAINT [DF_CapitalBudgetPurpose_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]        INT          NOT NULL,
    [UPDATE_DATE]               DATETIME     NULL,
    [UPDATED_BY_USER_ID]        INT          NULL,
    CONSTRAINT [PK_CapitalBudgetPurpose] PRIMARY KEY CLUSTERED ([CAPITAL_BUDGET_PURPOSE_ID] ASC),
    CONSTRAINT [FK_CapitalBudgetPurpose_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalBudgetPurpose_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

