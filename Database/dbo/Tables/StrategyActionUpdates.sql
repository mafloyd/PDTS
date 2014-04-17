CREATE TABLE [dbo].[StrategyActionUpdates] (
    [STRATEGY_ACTION_UPDATE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [STRATEGY_ID]               INT            NOT NULL,
    [ACTION_DATE]               DATETIME       CONSTRAINT [DF_StrategyActionUpdates_ACTION_DATE] DEFAULT (getdate()) NOT NULL,
    [ACTION]                    VARCHAR (5000) NOT NULL,
    [CREATED_BY_USER_ID]        INT            NOT NULL,
    [CREATE_DATE]               DATETIME       CONSTRAINT [DF_StrategyActionUpdates_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [RECURRING]                 BIT            CONSTRAINT [DF_StrategyActionUpdates_RECURRING] DEFAULT ((0)) NOT NULL,
    [DATE_OF_ORIGIN]            DATETIME       NOT NULL,
    [VALUE]                     VARCHAR (50)   NULL,
    [DELETED]                   BIT            CONSTRAINT [DF_StrategyActionUpdates_DELETED] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_StrategyActionUpdates] PRIMARY KEY CLUSTERED ([STRATEGY_ACTION_UPDATE_ID] ASC),
    CONSTRAINT [FK_StrategyActionUpdates_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_StrategyActionUpdates_Strategy] FOREIGN KEY ([STRATEGY_ID]) REFERENCES [dbo].[Strategy] ([STRATEGY_ID]) ON DELETE CASCADE
);

