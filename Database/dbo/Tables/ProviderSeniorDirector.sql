CREATE TABLE [dbo].[ProviderSeniorDirector] (
    [PROVIDER_SENIOR_DIRECTOR_ID] INT      IDENTITY (1, 1) NOT NULL,
    [CREATE_DATE]                 DATETIME CONSTRAINT [DF_ProviderSeniorDirector_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT      NOT NULL,
    [UPDATE_DATE]                 DATETIME NULL,
    [UPDATED_BY_USER_ID]          INT      NULL,
    [USER_ID]                     INT      NULL,
    CONSTRAINT [PK_ProviderSeniorDirector] PRIMARY KEY CLUSTERED ([PROVIDER_SENIOR_DIRECTOR_ID] ASC),
    CONSTRAINT [FK_ProviderSeniorDirector_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderSeniorDirector_PdtsUser] FOREIGN KEY ([USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderSeniorDirector_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

