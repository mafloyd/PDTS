CREATE TABLE [dbo].[DailyObsVisits] (
    [DAILY_OBS_VISITS_ID]    INT         IDENTITY (1, 1) NOT NULL,
    [COID]                   VARCHAR (5) NOT NULL,
    [YEAR]                   INT         NOT NULL,
    [MONTHNO]                INT         NOT NULL,
    [DAY]                    INT         NOT NULL,
    [OBS_VISITS_DATE]        DATETIME    NOT NULL,
    [OBS_VISITS]             INT         NOT NULL,
    [CREATE_DATE]            DATETIME    CONSTRAINT [DF_DailyObsVisits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]     INT         NOT NULL,
    [UPDATE_DATE]            DATETIME    NULL,
    [UPDATED_BY_USER_ID]     INT         NULL,
    [QUARTER]                TINYINT     NULL,
    [VISITS_EXCLUDING_IP_OB] INT         CONSTRAINT [DF_DailyObsVisits_VISITS_EXCLUDING_IP_OP] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DailyObsVisits] PRIMARY KEY CLUSTERED ([DAILY_OBS_VISITS_ID] ASC),
    CONSTRAINT [FK_DailyObsVisits_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyObsVisits_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

