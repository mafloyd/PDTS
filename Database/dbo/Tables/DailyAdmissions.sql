CREATE TABLE [dbo].[DailyAdmissions] (
    [DAILY_ADMISSIONS_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                VARCHAR (5) NOT NULL,
    [YEAR]                INT         NOT NULL,
    [MONTHNO]             SMALLINT    NOT NULL,
    [DAY]                 INT         NOT NULL,
    [ADMISSIONS_DATE]     DATETIME    NOT NULL,
    [ADMITS]              INT         NOT NULL,
    [CREATE_DATE]         DATETIME    CONSTRAINT [DF_DailyAdmissions_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]  INT         NOT NULL,
    [UPDATE_DATE]         DATETIME    NULL,
    [UPDATED_BY_USER_ID]  INT         NULL,
    [QUARTER]             TINYINT     NULL,
    CONSTRAINT [PK_DailyAdmissions] PRIMARY KEY CLUSTERED ([DAILY_ADMISSIONS_ID] ASC),
    CONSTRAINT [FK_DailyAdmissions_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyAdmissions_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyAdmissions_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

