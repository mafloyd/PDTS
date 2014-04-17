CREATE TABLE [dbo].[ProviderPracticePhone] (
    [PROVIDER_PRACTICE_PHONE_ID] INT      IDENTITY (1, 1) NOT NULL,
    [PHONE_TYPE_ID]              INT      NOT NULL,
    [AREA_CODE]                  SMALLINT NULL,
    [EXCHANGE]                   SMALLINT NULL,
    [LOCAL_NUMBER]               SMALLINT NULL,
    [PREFERRED]                  BIT      CONSTRAINT [DF_ProviderPracticePhone_PREFERRED] DEFAULT ((0)) NOT NULL,
    [ACTIVE]                     BIT      CONSTRAINT [DF_ProviderPracticePhone_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATE_DATE]                DATETIME CONSTRAINT [DF_ProviderPracticePhone_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]         INT      NOT NULL,
    [UPDATE_DATE]                DATETIME NULL,
    [UPDATED_BY_USER_ID]         INT      NULL,
    CONSTRAINT [PK_ProviderPracticePhone] PRIMARY KEY CLUSTERED ([PROVIDER_PRACTICE_PHONE_ID] ASC),
    CONSTRAINT [FK_ProviderPracticePhone_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderPracticePhone_Phone_Type] FOREIGN KEY ([PHONE_TYPE_ID]) REFERENCES [dbo].[Phone_Type] ([PHONE_TYPE_ID]),
    CONSTRAINT [FK_ProviderPracticePhone_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

