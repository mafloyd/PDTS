CREATE TABLE [dbo].[StrategyMeasurableResult] (
    [MEASURABLE_RESULT_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                 VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_MeasurableResults] PRIMARY KEY CLUSTERED ([MEASURABLE_RESULT_ID] ASC)
);

