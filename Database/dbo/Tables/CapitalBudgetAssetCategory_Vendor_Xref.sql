CREATE TABLE [dbo].[CapitalBudgetAssetCategory_Vendor_Xref] (
    [CAPITAL_BUDGET_ASSET_CATEGORY_VENDOR_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [CAPITAL_BUDGET_ASSET_CATEGORY_ID]             INT NOT NULL,
    [VENDOR_ID]                                    INT NOT NULL,
    CONSTRAINT [PK_CapitalBudgetAssetCategory_Vendor_Xref] PRIMARY KEY CLUSTERED ([CAPITAL_BUDGET_ASSET_CATEGORY_VENDOR_XREF_ID] ASC),
    CONSTRAINT [FK_CapitalBudgetAssetCategory_Vendor_Xref_CapitalBudgetAssetCategory] FOREIGN KEY ([CAPITAL_BUDGET_ASSET_CATEGORY_ID]) REFERENCES [dbo].[CapitalBudgetAssetCategory] ([CAPITAL_BUDGET_ASSET_CATEGORY_ID]),
    CONSTRAINT [FK_CapitalBudgetAssetCategory_Vendor_Xref_Vendor] FOREIGN KEY ([VENDOR_ID]) REFERENCES [dbo].[Vendor] ([VENDOR_ID])
);

