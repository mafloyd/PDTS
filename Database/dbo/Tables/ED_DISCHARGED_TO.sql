﻿CREATE TABLE [dbo].[ED_DISCHARGED_TO] (
    [ED_DISCHARGED_TO_ID] INT           IDENTITY (1, 1) NOT NULL,
    [NAME]                VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_ED_DISCHARGED_TO] PRIMARY KEY CLUSTERED ([ED_DISCHARGED_TO_ID] ASC)
);

