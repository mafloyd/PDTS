CREATE TABLE [dbo].[DailyOPVisits] (
    [DAILY_OP_VISITS_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [YEAR]               INT         NOT NULL,
    [MONTHNO]            SMALLINT    NOT NULL,
    [DAY]                SMALLINT    NOT NULL,
    [OP_VISITS_DATE]     DATETIME    NOT NULL,
    [OP_VISITS]          INT         NOT NULL,
    [CREATE_DATE]        DATETIME    CONSTRAINT [DF_DailyOPVisits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    [QUARTER]            TINYINT     NULL,
    CONSTRAINT [PK_DailyOPVisits] PRIMARY KEY CLUSTERED ([DAILY_OP_VISITS_ID] ASC),
    CONSTRAINT [FK_DailyOPVisits_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyOPVisits_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyOPVisits_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

