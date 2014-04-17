CREATE TABLE [dbo].[ProviderVPPhysicianService] (
    [PROVIDER_VP_PHYSICIAN_SERVICES_ID] INT          IDENTITY (1, 1) NOT NULL,
    [FIRST_NAME]                        VARCHAR (50) NOT NULL,
    [LAST_NAME]                         VARCHAR (50) NOT NULL,
    [CREATE_DATE]                       DATETIME     CONSTRAINT [DF_ProviderVPPhysicianService_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                INT          NOT NULL,
    [UPDATE_DATE]                       DATETIME     NULL,
    [UPDATED_BY_USER_ID]                INT          NULL,
    [EMAIL]                             VARCHAR (50) NULL,
    CONSTRAINT [PK_ProviderVPPhysicianService] PRIMARY KEY CLUSTERED ([PROVIDER_VP_PHYSICIAN_SERVICES_ID] ASC),
    CONSTRAINT [FK_ProviderVPPhysicianService_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderVPPhysicianService_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

