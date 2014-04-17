﻿CREATE TABLE [dbo].[SURVEY_CATEGORY] (
    [CATEGORY_ID] INT           IDENTITY (1, 1) NOT NULL,
    [NAME]        VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_SURVEY_CATEGORY] PRIMARY KEY CLUSTERED ([CATEGORY_ID] ASC)
);
