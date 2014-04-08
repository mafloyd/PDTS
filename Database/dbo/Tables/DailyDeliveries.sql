CREATE TABLE [dbo].[DailyDeliveries] (
    [DAILY_DELIVERIES_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                VARCHAR (5) NOT NULL,
    [YEAR]                INT         NOT NULL,
    [MONTHNO]             INT         NOT NULL,
    [DAY]                 INT         NOT NULL,
    [DELIVERIES_DATE]     DATETIME    NOT NULL,
    [DELIVERIES]          INT         NOT NULL,
    [CREATE_DATE]         DATETIME    CONSTRAINT [DF_DailyDeliveries_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]  INT         NOT NULL,
    [UPDATE_DATE]         DATETIME    NULL,
    [UPDATED_BY_USER_ID]  INT         NULL,
    [QUARTER]             TINYINT     NULL,
    CONSTRAINT [PK_DailyDeliveries] PRIMARY KEY CLUSTERED ([DAILY_DELIVERIES_ID] ASC),
    CONSTRAINT [FK_DailyDeliveries_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_DailyDeliveries_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_DailyDeliveries_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

