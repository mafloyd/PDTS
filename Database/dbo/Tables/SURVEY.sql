﻿CREATE TABLE [dbo].[SURVEY] (
    [SURVEY_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]      VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SURVEY] PRIMARY KEY CLUSTERED ([SURVEY_ID] ASC)
);
