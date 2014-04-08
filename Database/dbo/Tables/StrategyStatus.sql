CREATE TABLE [dbo].[StrategyStatus] (
    [STRATEGY_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]               VARCHAR (50) NOT NULL,
    [ACTIVE]             BIT          CONSTRAINT [DF_StrategyStatus_ACTIVE] DEFAULT ((1)) NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_StrategyStatus_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    [SORT_ORDER]         SMALLINT     NULL,
    CONSTRAINT [PK_StrategyStatus] PRIMARY KEY CLUSTERED ([STRATEGY_STATUS_ID] ASC),
    CONSTRAINT [FK_StrategyStatus_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_StrategyStatus_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

