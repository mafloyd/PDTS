﻿CREATE TABLE [dbo].[ProviderPractice] (
    [PROVIDER_PRACTICE_ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [DBA_NAME]                               VARCHAR (100) NOT NULL,
    [LEGAL_ENTITY]                           VARCHAR (100) NULL,
    [TAX_ID]                                 VARCHAR (50)  NULL,
    [OFFICE_MANAGER_LAST_NAME]               VARCHAR (50)  NULL,
    [OFFICE_MANAGER_EMAIL]                   VARCHAR (50)  NULL,
    [CREATE_DATE]                            DATETIME      CONSTRAINT [DF_ProviderPractice_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                     INT           NOT NULL,
    [UPDATE_DATE]                            DATETIME      NULL,
    [UPDATED_BY_USER_ID]                     INT           NULL,
    [PROVIDER_PRACTICE_STATUS_ID]            INT           NULL,
    [PROVIDER_PRACTICE_MANAGEMENT_SYSTEM_ID] INT           NULL,
    [OFFICE_MANAGER_FIRST_NAME]              VARCHAR (50)  NULL,
    [PM_PROJECTED_IMPLEMENTATION_DATE]       DATETIME      NULL,
    [PM_SYSTEM_ACCOUNT_NUMBER]               VARCHAR (50)  NULL,
    [PAYROLL_SYSTEM]                         VARCHAR (50)  NULL,
    [OTHER_PRACTICE_MANAGEMENT_SYSTEM]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_ProviderPractice] PRIMARY KEY CLUSTERED ([PROVIDER_PRACTICE_ID] ASC),
    CONSTRAINT [FK_ProviderPractice_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderPractice_PROVIDER_PRACTICE_MANAGEMENT_SYSTEM] FOREIGN KEY ([PROVIDER_PRACTICE_MANAGEMENT_SYSTEM_ID]) REFERENCES [dbo].[PROVIDER_PRACTICE_MANAGEMENT_SYSTEM] ([PROVIDER_PRACTICE_MANAGMENT_SYSTEM_ID]),
    CONSTRAINT [FK_ProviderPractice_PROVIDER_PRACTICE_STATUS] FOREIGN KEY ([PROVIDER_PRACTICE_STATUS_ID]) REFERENCES [dbo].[PROVIDER_PRACTICE_STATUS] ([PROVIDER_PRACTICE_STATUS_ID]),
    CONSTRAINT [FK_ProviderPractice_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

