﻿CREATE TABLE [dbo].[CHEST_PAIN_MODE_OF_ARRIVAL] (
    [CHEST_PAIN_MODE_OF_ARRIVAL_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                          VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CHEST_PAIN_MODE_OF_ARRIVAL] PRIMARY KEY CLUSTERED ([CHEST_PAIN_MODE_OF_ARRIVAL_ID] ASC)
);

