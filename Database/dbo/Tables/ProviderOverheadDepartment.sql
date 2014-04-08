CREATE TABLE [dbo].[ProviderOverheadDepartment] (
    [PROVIDER_OVERHEAD_DEPT_ID] INT          IDENTITY (1, 1) NOT NULL,
    [DEPT_NUMBER]               INT          NOT NULL,
    [NAME]                      VARCHAR (50) NULL,
    [CREATE_DATE]               DATETIME     CONSTRAINT [DF_ProviderOverheadDepartment_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]        INT          NOT NULL,
    [UPDATE_DATE]               DATETIME     NULL,
    [UPDATED_BY_USER_ID]        INT          NULL,
    CONSTRAINT [PK_ProviderOverheadDepartment] PRIMARY KEY CLUSTERED ([PROVIDER_OVERHEAD_DEPT_ID] ASC),
    CONSTRAINT [FK_ProviderOverheadDepartment_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderOverheadDepartment_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

