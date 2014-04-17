CREATE TABLE [dbo].[ProviderCredentialType] (
    [PROVIDER_CREDENTIAL_TYPE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                        VARCHAR (50) NOT NULL,
    [CREATE_DATE]                 DATETIME     CONSTRAINT [DF_ProviderCredentialType_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT          NOT NULL,
    [UPDATE_DATE]                 NCHAR (10)   NULL,
    [UPDATED_BY_USER_ID]          INT          NULL,
    CONSTRAINT [PK_ProviderCredentialType] PRIMARY KEY CLUSTERED ([PROVIDER_CREDENTIAL_TYPE_ID] ASC),
    CONSTRAINT [FK_ProviderCredentialType_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderCredentialType_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

