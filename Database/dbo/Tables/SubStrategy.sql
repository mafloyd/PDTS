CREATE TABLE [dbo].[SubStrategy] (
    [SUB_STRATEGY_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [STRATEGY_ID]              INT            NOT NULL,
    [SUB_STRATEGY]             VARCHAR (1000) NOT NULL,
    [TACTIC]                   VARCHAR (1000) NULL,
    [CREATED_BY_USER_ID]       INT            NOT NULL,
    [CREATE_DATE]              DATETIME       CONSTRAINT [DF_SubStrategy_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [UPDATED_BY_USER_ID]       INT            NULL,
    [UPDATE_DATE]              DATETIME       NULL,
    [STRATEGY_STATUS_ID]       INT            CONSTRAINT [DF_SubStrategy_STRATEGY_STATUS_ID] DEFAULT ((1)) NOT NULL,
    [SORT_ORDER]               INT            NULL,
    [PROJECT_OWNER]            VARCHAR (100)  NULL,
    [TARGETED_COMPLETION_DATE] VARCHAR (50)   NULL,
    CONSTRAINT [PK_SubStrategy] PRIMARY KEY CLUSTERED ([SUB_STRATEGY_ID] ASC),
    CONSTRAINT [FK_SubStrategy_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_SubStrategy_Strategy] FOREIGN KEY ([STRATEGY_ID]) REFERENCES [dbo].[Strategy] ([STRATEGY_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_SubStrategy_StrategyStatus] FOREIGN KEY ([STRATEGY_STATUS_ID]) REFERENCES [dbo].[StrategyStatus] ([STRATEGY_STATUS_ID]),
    CONSTRAINT [FK_SubStrategy_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

