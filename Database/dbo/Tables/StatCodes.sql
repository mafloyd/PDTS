﻿CREATE TABLE [dbo].[StatCodes] (
    [STAT_CODE_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [STAT_CODE]      VARCHAR (5)  NOT NULL,
    [STAT_CODE_DESC] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_StatCodes_1] PRIMARY KEY CLUSTERED ([STAT_CODE_ID] ASC)
);
