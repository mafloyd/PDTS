﻿CREATE TABLE [dbo].[CapitalBudget] (
    [CAPITAL_BUDGET_ID]                INT             IDENTITY (1, 1) NOT NULL,
    [COID]                             VARCHAR (5)     NOT NULL,
    [CAPITAL_DEPT_ID]                  INT             NOT NULL,
    [DESCRIPTION]                      VARCHAR (100)   NOT NULL,
    [COST]                             DECIMAL (10, 2) NOT NULL,
    [BUDGET_YEAR]                      INT             NOT NULL,
    [QUARTER_REQUIRED]                 SMALLINT        NOT NULL,
    [CAPITAL_BUDGET_ASSET_CATEGORY_ID] INT             NOT NULL,
    [CAPITAL_BUDGET_PURPOSE_ID]        INT             NOT NULL,
    [CAPITAL_BUDGET_TYPE_ID]           INT             NOT NULL,
    [VENDOR_ID]                        INT             NOT NULL,
    [CAPITAL_BUDGET_ASSET_CLASS_ID]    INT             NOT NULL,
    [COMMENT]                          VARCHAR (1000)  NULL,
    [OTHER_ASSET_CATEGORY_DESC]        VARCHAR (500)   NULL,
    [CREATE_DATE]                      DATETIME        CONSTRAINT [DF_CapitalBudget_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]               INT             NOT NULL,
    [UPDATE_DATE]                      DATETIME        NULL,
    [UPDATED_BY_USER_ID]               INT             NULL,
    [USEFUL_LIVES]                     INT             CONSTRAINT [DF_CapitalBudget_USEFUL_LIVES] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CapitalBudget] PRIMARY KEY CLUSTERED ([CAPITAL_BUDGET_ID] ASC),
    CONSTRAINT [FK_CapitalBudget_CapitalBudgetAssetCategory] FOREIGN KEY ([CAPITAL_BUDGET_ASSET_CATEGORY_ID]) REFERENCES [dbo].[CapitalBudgetAssetCategory] ([CAPITAL_BUDGET_ASSET_CATEGORY_ID]),
    CONSTRAINT [FK_CapitalBudget_CapitalBudgetAssetClass] FOREIGN KEY ([CAPITAL_BUDGET_ASSET_CLASS_ID]) REFERENCES [dbo].[CapitalBudgetAssetClass] ([CAPITAL_BUDGET_ASSET_CLASS_ID]),
    CONSTRAINT [FK_CapitalBudget_CapitalBudgetPurpose] FOREIGN KEY ([CAPITAL_BUDGET_PURPOSE_ID]) REFERENCES [dbo].[CapitalBudgetPurpose] ([CAPITAL_BUDGET_PURPOSE_ID]),
    CONSTRAINT [FK_CapitalBudget_CapitalBudgetType] FOREIGN KEY ([CAPITAL_BUDGET_TYPE_ID]) REFERENCES [dbo].[CapitalBudgetType] ([CAPITAL_BUDGET_TYPE_ID]),
    CONSTRAINT [FK_CapitalBudget_CapitalDept] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_CapitalBudget_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_CapitalBudget_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalBudget_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalBudget_Vendor] FOREIGN KEY ([VENDOR_ID]) REFERENCES [dbo].[Vendor] ([VENDOR_ID])
);
