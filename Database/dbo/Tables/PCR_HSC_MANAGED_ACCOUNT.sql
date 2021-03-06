﻿CREATE TABLE [dbo].[PCR_HSC_MANAGED_ACCOUNT] (
    [PCR_HSC_MANAGED_ACCOUNT_ID] INT      IDENTITY (1, 1) NOT NULL,
    [ACCOUNT]                    INT      NOT NULL,
    [ACTIVE]                     BIT      CONSTRAINT [DF_PCR_HSC_MANAGED_ACCOUNT_ACTIVE] DEFAULT ((0)) NOT NULL,
    [VALIDATE]                   BIT      CONSTRAINT [DF_PCR_HSC_MANAGED_ACCOUNT_VALIDATE] DEFAULT ((0)) NOT NULL,
    [REVIEW]                     BIT      CONSTRAINT [DF_PCR_HSC_MANAGED_ACCOUNT_REVIEW] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]                DATETIME CONSTRAINT [DF_PCR_HSC_MANAGED_ACCOUNT_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]         INT      NOT NULL,
    [UPDATE_DATE]                DATETIME NULL,
    [UPDATED_BY_USER_ID]         INT      NULL,
    CONSTRAINT [PK_PCR_HSC_MANAGED_ACCOUNT] PRIMARY KEY CLUSTERED ([PCR_HSC_MANAGED_ACCOUNT_ID] ASC),
    CONSTRAINT [FK_PCR_HSC_MANAGED_ACCOUNT_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PCR_HSC_MANAGED_ACCOUNT_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

