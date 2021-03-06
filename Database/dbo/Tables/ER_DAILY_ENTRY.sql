﻿CREATE TABLE [dbo].[ER_DAILY_ENTRY] (
    [ER_DAILY_ENTRY_ID]            INT             IDENTITY (1, 1) NOT NULL,
    [ER_DAILY_STATS_DEFINITION_ID] INT             NULL,
    [COID]                         VARCHAR (5)     NOT NULL,
    [YEAR]                         INT             NOT NULL,
    [MONTH]                        INT             NOT NULL,
    [DAY_1]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_1] DEFAULT ((0)) NOT NULL,
    [DAY_2]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_2] DEFAULT ((0)) NOT NULL,
    [DAY_3]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_3] DEFAULT ((0)) NOT NULL,
    [DAY_4]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_4] DEFAULT ((0)) NOT NULL,
    [DAY_5]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_5] DEFAULT ((0)) NOT NULL,
    [DAY_6]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_6] DEFAULT ((0)) NOT NULL,
    [DAY_7]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_7] DEFAULT ((0)) NOT NULL,
    [DAY_8]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_8] DEFAULT ((0)) NOT NULL,
    [DAY_9]                        DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_9] DEFAULT ((0)) NOT NULL,
    [DAY_10]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_10] DEFAULT ((0)) NOT NULL,
    [DAY_11]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_11] DEFAULT ((0)) NOT NULL,
    [DAY_12]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_12] DEFAULT ((0)) NOT NULL,
    [DAY_13]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_13] DEFAULT ((0)) NOT NULL,
    [DAY_14]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_14] DEFAULT ((0)) NOT NULL,
    [DAY_15]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_15] DEFAULT ((0)) NOT NULL,
    [DAY_16]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_16] DEFAULT ((0)) NOT NULL,
    [DAY_17]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_17] DEFAULT ((0)) NOT NULL,
    [DAY_18]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_18] DEFAULT ((0)) NOT NULL,
    [DAY_19]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_19] DEFAULT ((0)) NOT NULL,
    [DAY_20]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_20] DEFAULT ((0)) NOT NULL,
    [DAY_21]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_21] DEFAULT ((0)) NOT NULL,
    [DAY_22]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_22] DEFAULT ((0)) NOT NULL,
    [DAY_23]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_23] DEFAULT ((0)) NOT NULL,
    [DAY_24]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_24] DEFAULT ((0)) NOT NULL,
    [DAY_25]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_25] DEFAULT ((0)) NOT NULL,
    [DAY_26]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_26] DEFAULT ((0)) NOT NULL,
    [DAY_27]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_27] DEFAULT ((0)) NOT NULL,
    [DAY_28]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_28] DEFAULT ((0)) NOT NULL,
    [DAY_29]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_29] DEFAULT ((0)) NOT NULL,
    [DAY_30]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_30] DEFAULT ((0)) NOT NULL,
    [DAY_31]                       DECIMAL (10, 2) CONSTRAINT [DF_ER_DAILY_ENTRY_DAY_31] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]                  DATETIME        CONSTRAINT [DF_ER_DAILY_ENTRY_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]           INT             NOT NULL,
    [UPDATE_DATE]                  DATETIME        NULL,
    [UPDATED_BY_USER_ID]           INT             NULL,
    [TOTAL]                        DECIMAL (10, 2) NULL,
    [AVERAGE]                      DECIMAL (10, 2) NULL,
    [POINTS]                       INT             CONSTRAINT [DF_ER_DAILY_ENTRY_POINTS] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ER_DAILY_ENTRY] PRIMARY KEY CLUSTERED ([ER_DAILY_ENTRY_ID] ASC),
    CONSTRAINT [FK_ER_DAILY_ENTRY_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ER_DAILY_ENTRY_ER_DAILY_STATS_DEFINITION] FOREIGN KEY ([ER_DAILY_STATS_DEFINITION_ID]) REFERENCES [dbo].[ER_DAILY_STATS_DEFINITION] ([ER_DAILY_STATS_DEFINITION_ID]),
    CONSTRAINT [FK_ER_DAILY_ENTRY_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_ER_DAILY_ENTRY_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [IX_ER_DAILY_ENTRY] UNIQUE NONCLUSTERED ([COID] ASC, [ER_DAILY_STATS_DEFINITION_ID] ASC, [MONTH] ASC, [YEAR] ASC)
);

