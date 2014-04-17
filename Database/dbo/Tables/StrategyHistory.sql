CREATE TABLE [dbo].[StrategyHistory] (
    [STRATEGY_HISTORY_ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [STRATEGY_ID]                            INT            NOT NULL,
    [COID]                                   VARCHAR (5)    NOT NULL,
    [NAME]                                   VARCHAR (50)   NOT NULL,
    [CATEGORY_ID]                            INT            NOT NULL,
    [GOAL_TYPE_ID]                           INT            NOT NULL,
    [MEASURABLE_RESULT_ID]                   INT            NOT NULL,
    [OTHER_MEASURABLE_RESULT_TEXT]           VARCHAR (500)  NULL,
    [OTHER_MEASURABLE_RESULT_FREQUENCY_TEXT] VARCHAR (50)   NULL,
    [PRODUCT_LINE_ID]                        INT            NULL,
    [SPECIALTY_ID]                           INT            NULL,
    [ACTION]                                 VARCHAR (1000) NOT NULL,
    [OTHER_NOTES]                            VARCHAR (1000) NULL,
    [CREATE_DATE]                            DATETIME       NOT NULL,
    [CREATED_BY_USER_ID]                     INT            NOT NULL,
    [UPDATE_DATE]                            DATETIME       NULL,
    [UPDATED_BY_USER_ID]                     INT            NULL,
    CONSTRAINT [PK_StrategyHistory] PRIMARY KEY CLUSTERED ([STRATEGY_HISTORY_ID] ASC)
);

