﻿CREATE TABLE [dbo].[PROVIDER_STAFF_STATUS] (
    [PROVIDER_STAFF_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                     VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PROVIDER_STAFF_STATUS] PRIMARY KEY CLUSTERED ([PROVIDER_STAFF_STATUS_ID] ASC)
);

