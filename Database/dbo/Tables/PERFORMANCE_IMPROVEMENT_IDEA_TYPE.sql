﻿CREATE TABLE [dbo].[PERFORMANCE_IMPROVEMENT_IDEA_TYPE] (
    [PERFORMANCE_IMPROVEMENT_IDEA_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                                 VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PERFORMANCE_IMPROVEMENT_IDEA_TYPE] PRIMARY KEY CLUSTERED ([PERFORMANCE_IMPROVEMENT_IDEA_TYPE_ID] ASC)
);
