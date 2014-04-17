CREATE TABLE [dbo].[StrategyGoalType] (
    [GOAL_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]         VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_StrategyGoalType] PRIMARY KEY CLUSTERED ([GOAL_TYPE_ID] ASC)
);

