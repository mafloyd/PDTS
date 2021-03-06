﻿CREATE TABLE [dbo].[PROVIDER_PRACTICE_PHONE_XREF] (
    [PROVIDER_PRACTICE_PHONE_XREF] INT IDENTITY (1, 1) NOT NULL,
    [PROVIDER_PRACTICE_ID]         INT NOT NULL,
    [PROVIDER_PRACTICE_PHONE_ID]   INT NOT NULL,
    [ACTIVE]                       BIT CONSTRAINT [DF_PROVIDER_PRACTICE_PHONE_XREF_ACTIVE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PROVIDER_PRACTICE_PHONE_XREF] PRIMARY KEY CLUSTERED ([PROVIDER_PRACTICE_PHONE_XREF] ASC),
    CONSTRAINT [FK_PROVIDER_PRACTICE_PHONE_XREF_ProviderPractice] FOREIGN KEY ([PROVIDER_PRACTICE_ID]) REFERENCES [dbo].[ProviderPractice] ([PROVIDER_PRACTICE_ID]),
    CONSTRAINT [FK_PROVIDER_PRACTICE_PHONE_XREF_ProviderPracticePhone] FOREIGN KEY ([PROVIDER_PRACTICE_PHONE_ID]) REFERENCES [dbo].[ProviderPracticePhone] ([PROVIDER_PRACTICE_PHONE_ID])
);

