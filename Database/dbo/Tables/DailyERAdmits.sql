CREATE TABLE [dbo].[DailyERAdmits] (
    [DAILY_ER_ADMITS_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [YEAR]               INT         NOT NULL,
    [MONTHNO]            SMALLINT    NOT NULL,
    [DAY]                SMALLINT    NOT NULL,
    [ER_ADMITS_DATE]     DATETIME    NOT NULL,
    [ER_ADMITS]          INT         NOT NULL,
    [CREATE_DATE]        DATETIME    CONSTRAINT [DF_DailyERAdmits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    [QUARTER]            TINYINT     NULL,
    CONSTRAINT [PK_DailyERAdmits] PRIMARY KEY CLUSTERED ([DAILY_ER_ADMITS_ID] ASC),
    CONSTRAINT [FK_DailyERAdmits_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyERAdmits_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyERAdmits_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

