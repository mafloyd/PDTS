﻿CREATE TABLE [dbo].[PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF] (
    [PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF_ID] INT         IDENTITY (1, 1) NOT NULL,
    [PROVIDER_SENIOR_DIRECTOR_ID]               INT         NOT NULL,
    [COID]                                      VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF] PRIMARY KEY CLUSTERED ([PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF_ID] ASC),
    CONSTRAINT [FK_PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_PROVIDER_SENIOR_DIRECTOR_FACILITY_XREF_ProviderSeniorDirector] FOREIGN KEY ([PROVIDER_SENIOR_DIRECTOR_ID]) REFERENCES [dbo].[ProviderSeniorDirector] ([PROVIDER_SENIOR_DIRECTOR_ID])
);
