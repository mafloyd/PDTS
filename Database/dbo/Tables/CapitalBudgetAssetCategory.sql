CREATE TABLE [dbo].[CapitalBudgetAssetCategory] (
    [CAPITAL_BUDGET_ASSET_CATEGORY_ID] INT         IDENTITY (1, 1) NOT NULL,
    [NAME]                             NCHAR (100) NOT NULL,
    [CREATE_DATE]                      DATETIME    CONSTRAINT [DF_AssetCategory_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]               INT         NOT NULL,
    [UPDATE_DATE]                      DATETIME    NULL,
    [UPDATED_BY_USER_ID]               INT         NULL,
    CONSTRAINT [PK_AssetCategory] PRIMARY KEY CLUSTERED ([CAPITAL_BUDGET_ASSET_CATEGORY_ID] ASC),
    CONSTRAINT [FK_CapitalBudgetAssetCategory_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalBudgetAssetCategory_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

