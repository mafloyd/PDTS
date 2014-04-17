CREATE TABLE [dbo].[ER_DAILY_STATS_STAGE] (
    [COID]                         VARCHAR (5)   NOT NULL,
    [ER_DAILY_STATS_DEFINITION_ID] INT           NOT NULL,
    [YEAR]                         INT           NOT NULL,
    [MONTH]                        INT           NOT NULL,
    [DAY]                          INT           NOT NULL,
    [VALUE]                        INT           NOT NULL,
    [PROVIDER_7A]                  VARCHAR (100) NULL,
    [PROVIDER_11_11]               VARCHAR (100) NULL,
    [PROVIDER_7P]                  VARCHAR (100) NULL,
    [CREATE_DATE]                  DATETIME      CONSTRAINT [DF_ER_DAILY_STATS_STAGE_CREATE_DATE] DEFAULT (getdate()) NOT NULL
);

