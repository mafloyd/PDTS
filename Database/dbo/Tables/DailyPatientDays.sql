CREATE TABLE [dbo].[DailyPatientDays] (
    [DAILY_PATIENT_DAYS_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                  VARCHAR (5) NOT NULL,
    [YEAR]                  INT         NOT NULL,
    [MONTHNO]               SMALLINT    NOT NULL,
    [DAY]                   SMALLINT    NOT NULL,
    [PATIENT_DAYS_DATE]     DATETIME    NOT NULL,
    [PATIENT_DAYS]          INT         NOT NULL,
    [CREATE_DATE]           DATETIME    CONSTRAINT [DF_DailyPatientDays_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]    INT         NOT NULL,
    [UPDATE_DATE]           DATETIME    NULL,
    [UPDATED_BY_USER_ID]    INT         NULL,
    CONSTRAINT [PK_DailyPatientDays] PRIMARY KEY CLUSTERED ([DAILY_PATIENT_DAYS_ID] ASC),
    CONSTRAINT [FK_DailyPatientDays_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyPatientDays_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyPatientDays_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

