CREATE TABLE [dbo].[DailyERVisits] (
    [DAILY_ERVISITS_ID]  INT         IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [YEAR]               INT         NOT NULL,
    [MONTHNO]            INT         NOT NULL,
    [DAY]                INT         NOT NULL,
    [ER_VISITS_DATE]     DATETIME    NOT NULL,
    [ER_VISITS]          INT         NOT NULL,
    [CREATE_DATE]        DATETIME    CONSTRAINT [DF_DailyERVisits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    [QUARTER]            TINYINT     NULL,
    CONSTRAINT [PK_DailyERVisits] PRIMARY KEY CLUSTERED ([DAILY_ERVISITS_ID] ASC),
    CONSTRAINT [FK_DailyERVisits_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyERVisits_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyERVisits_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

