CREATE TABLE [dbo].[ProviderCredentialingNote] (
    [PROVIDER_CREDENTIALING_NOTE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [PROVIDER_CREDENTIALING_ID]      INT            NOT NULL,
    [NOTE]                           VARCHAR (1000) NOT NULL,
    [CREATE_DATE]                    DATETIME       CONSTRAINT [DF_ProviderCredentialingNote_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]             INT            NOT NULL,
    CONSTRAINT [PK_ProviderCredentialingNote] PRIMARY KEY CLUSTERED ([PROVIDER_CREDENTIALING_NOTE_ID] ASC),
    CONSTRAINT [FK_ProviderCredentialingNote_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderCredentialingNote_ProviderCredentialing] FOREIGN KEY ([PROVIDER_CREDENTIALING_ID]) REFERENCES [dbo].[ProviderCredentialing] ([PROVIDER_CREDENTIALING_ID])
);

