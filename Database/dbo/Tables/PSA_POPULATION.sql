﻿CREATE TABLE [dbo].[PSA_POPULATION] (
    [PSA_POPULATION_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]              VARCHAR (5) NOT NULL,
    [POPULATION]        BIGINT      NOT NULL,
    CONSTRAINT [PK_PSA_POPULATION] PRIMARY KEY CLUSTERED ([PSA_POPULATION_ID] ASC),
    CONSTRAINT [FK_PSA_POPULATION_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID])
);

