﻿CREATE TABLE [dbo].[PARALLON_SERVICE] (
    [PARALLON_SERVICE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PARALLON_SERVICE] PRIMARY KEY CLUSTERED ([PARALLON_SERVICE_ID] ASC)
);
