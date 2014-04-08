CREATE TABLE [dbo].[DailyCardiacCathLabProcs] (
    [DAILY_CARDIAC_CATH_LAB_PROCEDURES_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                                 VARCHAR (5) NOT NULL,
    [YEAR]                                 INT         NOT NULL,
    [MONTHNO]                              SMALLINT    NOT NULL,
    [DAY]                                  SMALLINT    NOT NULL,
    [CATH_LAB_PROCEDURES_DATE]             DATETIME    NOT NULL,
    [CATH_LAB_PROCEDURES]                  INT         NOT NULL,
    [CREATE_DATE]                          DATETIME    CONSTRAINT [DF_DailyCardiacCathLabProcs_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                   INT         NOT NULL,
    [UPDATE_DATE]                          DATETIME    NULL,
    [UPDATED_BY_USER_ID]                   INT         NULL,
    [QUARTER]                              TINYINT     NULL,
    CONSTRAINT [PK_DailyCardiacCathLabProcs] PRIMARY KEY CLUSTERED ([DAILY_CARDIAC_CATH_LAB_PROCEDURES_ID] ASC),
    CONSTRAINT [FK_DailyCardiacCathLabProcs_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyCardiacCathLabProcs_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyCardiacCathLabProcs_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

