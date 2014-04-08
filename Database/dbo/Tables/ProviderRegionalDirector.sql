CREATE TABLE [dbo].[ProviderRegionalDirector] (
    [PROVIDER_REGIONAL_DIRECTOR_ID] INT          IDENTITY (1, 1) NOT NULL,
    [FIRST_NAME]                    VARCHAR (50) NOT NULL,
    [LAST_NAME]                     VARCHAR (50) NOT NULL,
    [CREATE_DATE]                   DATETIME     CONSTRAINT [DF_ProviderRegionalDirector_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]            INT          NOT NULL,
    [UPDATE_DATE]                   DATETIME     NULL,
    [UPDATED_BY_USER_ID]            INT          NULL,
    CONSTRAINT [PK_ProviderRegionalDirector] PRIMARY KEY CLUSTERED ([PROVIDER_REGIONAL_DIRECTOR_ID] ASC),
    CONSTRAINT [FK_ProviderRegionalDirector_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderRegionalDirector_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

