CREATE TABLE [dbo].[SubStrategyActionUpdate] (
    [SUB_STRATEGY_ACTION_UPDATE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [SUB_STRATEGY_ID]               INT            NOT NULL,
    [ACTION_DATE]                   DATETIME       CONSTRAINT [DF_SubStrategyActionUpdate_ACTION_DATE] DEFAULT (getdate()) NOT NULL,
    [ACTION]                        VARCHAR (5000) NOT NULL,
    [CREATED_BY_USER_ID]            INT            NOT NULL,
    [CREATE_DATE]                   DATETIME       CONSTRAINT [DF_SubStrategyActionUpdate_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [RECURRING]                     BIT            CONSTRAINT [DF_SubStrategyActionUpdate_RECURRING] DEFAULT ((0)) NOT NULL,
    [DATE_OF_ORIGIN]                DATETIME       CONSTRAINT [DF_SubStrategyActionUpdate_DATE_OF_ORIGIN] DEFAULT (getdate()) NOT NULL,
    [VALUE]                         VARCHAR (50)   NULL,
    [DELETED]                       BIT            CONSTRAINT [DF_SubStrategyActionUpdate_DELETED] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SubStrategyActionUpdate] PRIMARY KEY CLUSTERED ([SUB_STRATEGY_ACTION_UPDATE_ID] ASC),
    CONSTRAINT [FK_SubStrategyActionUpdate_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_SubStrategyActionUpdate_SubStrategy] FOREIGN KEY ([SUB_STRATEGY_ID]) REFERENCES [dbo].[SubStrategy] ([SUB_STRATEGY_ID]) ON DELETE CASCADE
);

