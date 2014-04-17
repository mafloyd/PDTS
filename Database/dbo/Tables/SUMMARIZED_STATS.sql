﻿CREATE TABLE [dbo].[SUMMARIZED_STATS] (
    [SUMMARIZED_STATS_ID]           INT             IDENTITY (1, 1) NOT NULL,
    [SUMMARIZED_STAT_DEFINITION_ID] INT             NOT NULL,
    [COID]                          VARCHAR (5)     NOT NULL,
    [YEAR]                          INT             NOT NULL,
    [JAN]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_JAN] DEFAULT ((0)) NOT NULL,
    [FEB]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_VALUE] DEFAULT ((0)) NOT NULL,
    [MAR]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_MAR] DEFAULT ((0)) NOT NULL,
    [APR]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_APR] DEFAULT ((0)) NOT NULL,
    [MAY]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_MAY] DEFAULT ((0)) NOT NULL,
    [JUN]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_JUN] DEFAULT ((0)) NOT NULL,
    [JUL]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_JUL] DEFAULT ((0)) NOT NULL,
    [AUG]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_AUG] DEFAULT ((0)) NOT NULL,
    [SEP]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_SEP] DEFAULT ((0)) NOT NULL,
    [OCT]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_OCT] DEFAULT ((0)) NOT NULL,
    [NOV]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_NOV] DEFAULT ((0)) NOT NULL,
    [DEC]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_DEC] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]                   DATETIME        CONSTRAINT [DF_SUMMARIZED_STATS_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [UPDATE_DATE]                   DATETIME        NULL,
    [Q1]                            DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_Q1] DEFAULT ((0)) NOT NULL,
    [Q2]                            DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_Q2] DEFAULT ((0)) NOT NULL,
    [Q3]                            DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_Q3] DEFAULT ((0)) NOT NULL,
    [Q4]                            DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_Q4] DEFAULT ((0)) NOT NULL,
    [YTD]                           DECIMAL (18, 2) CONSTRAINT [DF_SUMMARIZED_STATS_YTD] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SUMMARIZED_STATS_1] PRIMARY KEY CLUSTERED ([SUMMARIZED_STATS_ID] ASC),
    CONSTRAINT [FK_SUMMARIZED_STATS_SUMMARIZED_STAT_DEFINITIONS] FOREIGN KEY ([SUMMARIZED_STAT_DEFINITION_ID]) REFERENCES [dbo].[SUMMARIZED_STAT_DEFINITIONS] ([SUMMARIZED_STAT_DEFINITION_ID])
);
