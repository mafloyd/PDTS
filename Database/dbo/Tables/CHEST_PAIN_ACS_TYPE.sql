﻿CREATE TABLE [dbo].[CHEST_PAIN_ACS_TYPE] (
    [CHEST_PAIN_ACS_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CHEST_PAIN_ACS_TYPE] PRIMARY KEY CLUSTERED ([CHEST_PAIN_ACS_TYPE_ID] ASC)
);

