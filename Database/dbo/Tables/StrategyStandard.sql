CREATE TABLE [dbo].[StrategyStandard] (
    [STANDARD_STRATEGY_ID] INT           IDENTITY (1, 1) NOT NULL,
    [CATEGORY_ID]          INT           NOT NULL,
    [GOAL_TYPE_ID]         INT           NOT NULL,
    [NAME]                 VARCHAR (100) NOT NULL,
    [ACTIVE]               BIT           CONSTRAINT [DF_StrategyStandardQuality_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATE_DATE]          DATETIME      CONSTRAINT [DF_StrategyStandardQuality_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]   INT           NOT NULL,
    [UPDATE_DATE]          DATETIME      NULL,
    [UPDATED_BY_USER_ID]   INT           NULL,
    CONSTRAINT [PK_StrategyStandardQuality] PRIMARY KEY CLUSTERED ([STANDARD_STRATEGY_ID] ASC),
    CONSTRAINT [FK_StrategyStandardQuality_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_StrategyStandardQuality_StrategyCategory] FOREIGN KEY ([CATEGORY_ID]) REFERENCES [dbo].[StrategyCategory] ([CATEGORY_ID]),
    CONSTRAINT [FK_StrategyStandardQuality_StrategyGoalType] FOREIGN KEY ([GOAL_TYPE_ID]) REFERENCES [dbo].[StrategyGoalType] ([GOAL_TYPE_ID]),
    CONSTRAINT [FK_StrategyStandardQuality_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

