CREATE TABLE [dbo].[DailyMcareAcuteAdmits] (
    [DAILY_MCARE_ACUTE_ADMITS] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                     VARCHAR (5) NOT NULL,
    [YEAR]                     INT         NOT NULL,
    [MONTHNO]                  SMALLINT    NOT NULL,
    [DAY]                      SMALLINT    NOT NULL,
    [ADMITS_DATE]              DATETIME    NOT NULL,
    [ADMITS]                   INT         NOT NULL,
    [CREATE_DATE]              DATETIME    CONSTRAINT [DF_DailyMcareAcuteAdmits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]       INT         NOT NULL,
    [UPDATE_DATE]              DATETIME    NULL,
    [UPDATED_BY_USER_ID]       INT         NULL,
    [QUARTER]                  TINYINT     NULL,
    CONSTRAINT [PK_DailyMcareAcuteAdmits] PRIMARY KEY CLUSTERED ([DAILY_MCARE_ACUTE_ADMITS] ASC),
    CONSTRAINT [FK_DailyMcareAcuteAdmits_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyMcareAcuteAdmits_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyMcareAcuteAdmits_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

