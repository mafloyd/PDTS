CREATE TABLE [dbo].[CapitalBudgetType] (
    [CAPITAL_BUDGET_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                   VARCHAR (50) NOT NULL,
    [CREATE_DATE]            DATETIME     CONSTRAINT [DF_CapitalBudgetType_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]     INT          NOT NULL,
    [UPDATE_DATE]            DATETIME     NULL,
    [UPDATED_BY_USER_ID]     INT          NULL,
    CONSTRAINT [PK_CapitalBudgetType] PRIMARY KEY CLUSTERED ([CAPITAL_BUDGET_TYPE_ID] ASC),
    CONSTRAINT [FK_CapitalBudgetType_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalBudgetType_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

