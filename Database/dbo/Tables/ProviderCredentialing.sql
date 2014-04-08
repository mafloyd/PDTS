CREATE TABLE [dbo].[ProviderCredentialing] (
    [PROVIDER_CREDENTIALING_ID]   INT      IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]            INT      NOT NULL,
    [PROVIDER_CREDENTIAL_TYPE_ID] INT      NOT NULL,
    [SENT_DATE]                   DATETIME NULL,
    [APPROVED_DATE]               DATETIME NULL,
    [EFFECTIVE_DATE]              DATETIME NULL,
    [CREATE_DATE]                 DATETIME CONSTRAINT [DF_ProviderCredentialing_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT      NOT NULL,
    [UPDATE_DATE]                 DATETIME NULL,
    [UPDATED_BY_USER_ID]          INT      NULL,
    CONSTRAINT [PK_ProviderCredentialing] PRIMARY KEY CLUSTERED ([PROVIDER_CREDENTIALING_ID] ASC),
    CONSTRAINT [FK_ProviderCredentialing_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderCredentialing_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProviderCredentialing_ProviderCredentialType] FOREIGN KEY ([PROVIDER_CREDENTIAL_TYPE_ID]) REFERENCES [dbo].[ProviderCredentialType] ([PROVIDER_CREDENTIAL_TYPE_ID]),
    CONSTRAINT [FK_ProviderCredentialing_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

