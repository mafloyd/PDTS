﻿CREATE TABLE [dbo].[ProviderCredential] (
    [PROVIDER_CREDENTIAL_ID] INT          IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]       INT          NOT NULL,
    [NPPES_LOGIN]            VARCHAR (50) NULL,
    [NPPES_PASSWORD]         VARCHAR (50) NULL,
    [RESPONSIBLE_PARTY]      VARCHAR (50) NULL,
    [CREATE_DATE]            DATETIME     CONSTRAINT [DF_ProviderCredential_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]     INT          NOT NULL,
    [UPDATE_DATE]            DATETIME     NULL,
    [UPDATED_BY_USER_ID]     INT          NULL,
    CONSTRAINT [PK_ProviderCredential] PRIMARY KEY CLUSTERED ([PROVIDER_CREDENTIAL_ID] ASC),
    CONSTRAINT [FK_ProviderCredential_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderCredential_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderCredential_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

