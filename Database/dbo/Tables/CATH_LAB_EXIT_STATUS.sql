﻿CREATE TABLE [dbo].[CATH_LAB_EXIT_STATUS] (
    [CATH_LAB_EXIT_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CATH_LAB_EXIT_STATUS] PRIMARY KEY CLUSTERED ([CATH_LAB_EXIT_STATUS_ID] ASC)
);
