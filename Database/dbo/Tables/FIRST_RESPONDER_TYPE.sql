﻿CREATE TABLE [dbo].[FIRST_RESPONDER_TYPE] (
    [FIRST_RESPONDER_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_FIRST_RESPONDER_TYPE] PRIMARY KEY CLUSTERED ([FIRST_RESPONDER_TYPE_ID] ASC)
);

