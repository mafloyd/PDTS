﻿CREATE TABLE [dbo].[EMPLOYED_PROVIDER_STATUS] (
    [EMPLOYED_PROVIDER_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                        VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EMPLOYED_PROVIDER_STATUS] PRIMARY KEY CLUSTERED ([EMPLOYED_PROVIDER_STATUS_ID] ASC)
);

