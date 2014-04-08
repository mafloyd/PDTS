CREATE TABLE [dbo].[User_StrategyCategory_Xref] (
    [USER_STRATEGYCATEGORY_XREF_ID] INT      IDENTITY (1, 1) NOT NULL,
    [USER_ID]                       INT      NOT NULL,
    [CATEGORY_ID]                   INT      NOT NULL,
    [ACTIVE]                        INT      NOT NULL,
    [CREATE_DATE]                   DATETIME CONSTRAINT [DF_User_StrategyCategory_Xref_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]            INT      NOT NULL,
    [UPDATE_DATE]                   DATETIME NULL,
    [UPDATED_BY_USER_ID]            INT      NULL,
    CONSTRAINT [PK_User_StrategyCategory_Xref] PRIMARY KEY CLUSTERED ([USER_STRATEGYCATEGORY_XREF_ID] ASC),
    CONSTRAINT [FK_User_StrategyCategory_Xref_PdtsUser] FOREIGN KEY ([USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_StrategyCategory_Xref_PdtsUser1] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_StrategyCategory_Xref_PdtsUser2] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_StrategyCategory_Xref_StrategyCategory] FOREIGN KEY ([CATEGORY_ID]) REFERENCES [dbo].[StrategyCategory] ([CATEGORY_ID])
);

