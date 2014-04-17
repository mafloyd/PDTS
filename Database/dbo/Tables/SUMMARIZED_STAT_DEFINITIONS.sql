﻿CREATE TABLE [dbo].[SUMMARIZED_STAT_DEFINITIONS] (
    [SUMMARIZED_STAT_DEFINITION_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                          VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SUMMARIZED_STATS] PRIMARY KEY CLUSTERED ([SUMMARIZED_STAT_DEFINITION_ID] ASC)
);
