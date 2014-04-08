CREATE TABLE [dbo].[ProviderDepartment] (
    [PROVIDER_DEPT_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [DEPT_NUMBER]        INT          NOT NULL,
    [NAME]               VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_ProviderDepartment_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_ProviderDepartment] PRIMARY KEY CLUSTERED ([PROVIDER_DEPT_ID] ASC),
    CONSTRAINT [FK_ProviderDepartment_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderDepartment_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

