﻿CREATE TABLE [dbo].[SPECIALTY_GROUP_TOP_LEVEL] (
    [SPECIALTY_GROUP_TOP_LEVEL_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                         VARCHAR (50) NOT NULL,
    [SORT_ORDER]                   TINYINT      NOT NULL,
    CONSTRAINT [PK_SPECIALTY_GROUP_TOP_LEVEL] PRIMARY KEY CLUSTERED ([SPECIALTY_GROUP_TOP_LEVEL_ID] ASC)
);
