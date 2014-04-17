﻿CREATE TABLE [dbo].[PERFORMANCE_IMPROVEMENT_TEAM] (
    [PERFORMANCE_IMPROVEMENT_TEAM_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                            VARCHAR (50) NOT NULL,
    [ABBREVIATED_NAME]                VARCHAR (3)  NOT NULL,
    CONSTRAINT [PK_PERFORMANCE_IMPROVEMENT_TEAM] PRIMARY KEY CLUSTERED ([PERFORMANCE_IMPROVEMENT_TEAM_ID] ASC)
);
