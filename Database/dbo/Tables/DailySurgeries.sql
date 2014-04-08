CREATE TABLE [dbo].[DailySurgeries] (
    [DAILY_SURGERIES_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [YEAR]               INT         NOT NULL,
    [MONTHNO]            INT         NOT NULL,
    [DAY]                INT         NOT NULL,
    [SURGERIES_DATE]     DATETIME    NOT NULL,
    [IP]                 INT         NOT NULL,
    [OUTP]               INT         NOT NULL,
    [CREATED_DATE]       DATETIME    CONSTRAINT [DF_DailySurgeries_CREATED_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    [QUARTER]            TINYINT     NULL,
    CONSTRAINT [PK_DailySurgeries] PRIMARY KEY CLUSTERED ([DAILY_SURGERIES_ID] ASC),
    CONSTRAINT [FK_DailySurgeries_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailySurgeries_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailySurgeries_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

