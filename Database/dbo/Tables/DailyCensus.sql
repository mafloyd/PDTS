CREATE TABLE [dbo].[DailyCensus] (
    [DAILY_CENSUS_ID]    INT         IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [YEAR]               INT         NOT NULL,
    [MONTHNO]            INT         NOT NULL,
    [DAY]                INT         NOT NULL,
    [CENSUS_DATE]        DATETIME    NOT NULL,
    [CENSUS]             INT         NOT NULL,
    [CREATE_DATE]        DATETIME    CONSTRAINT [DF_DailyCensus_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    [QUARTER]            TINYINT     NULL,
    CONSTRAINT [PK_DailyCensus] PRIMARY KEY CLUSTERED ([DAILY_CENSUS_ID] ASC),
    CONSTRAINT [FK_DailyCensus_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyCensus_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyCensus_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

