CREATE TABLE [dbo].[StrategyCategory] (
    [CATEGORY_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]        VARCHAR (50) NOT NULL,
    [SORT_ORDER]  INT          NULL,
    CONSTRAINT [PK_StrategyCategory] PRIMARY KEY CLUSTERED ([CATEGORY_ID] ASC)
);

