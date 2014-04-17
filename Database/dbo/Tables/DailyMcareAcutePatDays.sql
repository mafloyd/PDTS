CREATE TABLE [dbo].[DailyMcareAcutePatDays] (
    [DAILY_MCARE_ACUTE_PATDAYS_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                         VARCHAR (5) NOT NULL,
    [YEAR]                         INT         NOT NULL,
    [MONTHNO]                      SMALLINT    NOT NULL,
    [DAY]                          SMALLINT    NOT NULL,
    [PATDAYS_DATE]                 DATETIME    NOT NULL,
    [PAT_DAYS]                     INT         NOT NULL,
    [CREATE_DATE]                  DATETIME    CONSTRAINT [DF_DailyMcareAcutePatDays_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]           INT         NOT NULL,
    [UPDATE_DATE]                  DATETIME    NULL,
    [UPDATED_BY_USER_ID]           INT         NULL,
    [QUARTER]                      TINYINT     NULL,
    CONSTRAINT [PK_DailyMcareAcutePatDays] PRIMARY KEY CLUSTERED ([DAILY_MCARE_ACUTE_PATDAYS_ID] ASC),
    CONSTRAINT [FK_DailyMcareAcutePatDays_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyMcareAcutePatDays_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyMcareAcutePatDays_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

