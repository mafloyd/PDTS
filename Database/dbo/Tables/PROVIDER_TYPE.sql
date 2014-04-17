﻿CREATE TABLE [dbo].[PROVIDER_TYPE] (
    [PROVIDER_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PROVIDER_TYPE] PRIMARY KEY CLUSTERED ([PROVIDER_TYPE_ID] ASC)
);

