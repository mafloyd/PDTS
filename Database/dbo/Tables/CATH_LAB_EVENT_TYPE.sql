﻿CREATE TABLE [dbo].[CATH_LAB_EVENT_TYPE] (
    [CATH_LAB_EVENT_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CATH_LAB_EVENT_TYPE] PRIMARY KEY CLUSTERED ([CATH_LAB_EVENT_TYPE_ID] ASC)
);
