CREATE TABLE [dbo].[StrategyProductLine] (
    [PRODUCT_LINE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]            VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_StrategyProductLine] PRIMARY KEY CLUSTERED ([PRODUCT_LINE_ID] ASC)
);

