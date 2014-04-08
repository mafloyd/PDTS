﻿CREATE TABLE [dbo].[ProviderContract] (
    [PROVIDER_CONTRACT_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [CONTRACT_START_DATE]   DATETIME       NULL,
    [CONTRACTUAL_TERM_DATE] DATETIME       NULL,
    [TERMS]                 VARCHAR (200)  NULL,
    [PAYROLL_START_DATE]    DATETIME       NULL,
    [BENEFITS]              VARCHAR (200)  NULL,
    [SALARY]                MONEY          NULL,
    [IN_BONUS]              BIT            CONSTRAINT [DF_ProviderContract_IN_BONUS] DEFAULT ((0)) NOT NULL,
    [TERM_DATE]             DATETIME       NULL,
    [TERM_STATUS_ID]        INT            NULL,
    [TERM_EXPLANATION]      VARCHAR (200)  NULL,
    [CREATE_DATE]           DATETIME       CONSTRAINT [DF_ProviderContract_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]    INT            NOT NULL,
    [UPDATE_DATE]           DATETIME       NULL,
    [UPDATED_BY_USER_ID]    INT            NULL,
    [PDTS_PROVIDER_ID]      INT            NOT NULL,
    [COMMENTS]              VARCHAR (1000) NULL,
    [CONTRACT_LENGTH]       INT            NULL,
    CONSTRAINT [PK_ProviderContract] PRIMARY KEY CLUSTERED ([PROVIDER_CONTRACT_ID] ASC),
    CONSTRAINT [FK_ProviderContract_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderContract_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProviderContract_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

