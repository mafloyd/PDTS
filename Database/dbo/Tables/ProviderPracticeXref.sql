CREATE TABLE [dbo].[ProviderPracticeXref] (
    [PROVIDER_PRACTICE_XREF_ID] INT      IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]          INT      NOT NULL,
    [PROVIDER_PRACTICE_ID]      INT      NOT NULL,
    [ACTIVE]                    BIT      CONSTRAINT [DF_ProviderPracticeXref_ACTIVE] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]               DATETIME CONSTRAINT [DF_ProviderPracticeXref_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]        INT      NOT NULL,
    [UPDATE_DATE]               DATETIME NULL,
    [UPDATED_BY_USER_ID]        INT      NULL,
    [PREFERRED]                 BIT      CONSTRAINT [DF_ProviderPracticeXref_PREFERRED] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProviderPracticeXref] PRIMARY KEY CLUSTERED ([PROVIDER_PRACTICE_XREF_ID] ASC, [PDTS_PROVIDER_ID] ASC, [PROVIDER_PRACTICE_ID] ASC),
    CONSTRAINT [FK_ProviderPracticeXref_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderPracticeXref_ProviderPractice] FOREIGN KEY ([PROVIDER_PRACTICE_ID]) REFERENCES [dbo].[ProviderPractice] ([PROVIDER_PRACTICE_ID]),
    CONSTRAINT [FK_ProviderPracticeXref_ProviderPracticeXref] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]),
    CONSTRAINT [FK_ProviderPracticeXref_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

