﻿CREATE TABLE [dbo].[CHEST_PAIN_FACILITY] (
    [CHEST_PAIN_FACILITY_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CHEST_PAIN_FACILITY] PRIMARY KEY CLUSTERED ([CHEST_PAIN_FACILITY_ID] ASC)
);
